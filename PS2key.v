// module PS2Key(
//     input clk,
//     input PS2_clk,
//     input PS2_DAT,
//     output reg [7:0] data
// );
//     reg state;
//     reg clk2;
//     reg parity;
//     reg [3:0] counter;
//     reg lastclk;  // Declared but unused

//     initial begin
//         state = 0;
//         counter = 0;
//         data = 0;
//     end

//     // Synchronize PS2_clk with system clock
//     always @(posedge clk) begin
//         clk2 <= PS2_clk;
//     end

//     // PS2 data reception on falling edge of synchronized clock
//     always @(negedge clk2) begin
//         if (counter == 0 && state == 0) begin
//             state <= 1;
//             data <= 0;
//             counter <= 1;
//         end
//         else if (state == 1 && counter >= 1 && counter < 9) begin
//             data <= data | (PS2_DAT << (counter - 1));
//             counter <= counter + 1;
//         end
//         else if (state == 1 && counter == 9) begin
//             parity <= PS2_DAT;  // Parity bit captured (not verified)
//             counter <= counter + 1;
//         end
//         else if (state == 1 && counter == 10) begin
//             counter <= 0;
//             state <= 0;
//         end
//         else begin
//             state <= 0;
//             data <= 0;
//             counter <= 0;
//         end
//     end
// endmodule

module PS2Key (
    input clk,          // System clock
    input PS2_clk,   // Raw PS2 Clock input
    input PS2_DAT,   // Raw PS2 Data input
    output reg [7:0] data     // Received scan code
    // output reg data_valid // Goes high for one clk cycle when data_out is valid
);

    // --- Synchronization ---
    reg ps2_clk_sync1, ps2_clk_sync2;
    reg ps2_dat_sync1, ps2_dat_sync2;
    wire ps2_clk_synced = ps2_clk_sync2; // Use synchronized clock
    wire ps2_dat_synced = ps2_dat_sync2; // Use synchronized data

    always @(posedge clk) begin
        ps2_clk_sync1 <= PS2_clk;
        ps2_clk_sync2 <= ps2_clk_sync1;
        ps2_dat_sync1 <= PS2_DAT;
        ps2_dat_sync2 <= ps2_dat_sync1;
    end

    // Detect falling edge of synchronized PS2 clock
    reg ps2_clk_prev;
    wire ps2_clk_falling_edge;
    always @(posedge clk) begin
        ps2_clk_prev <= ps2_clk_synced;
    end
    assign ps2_clk_falling_edge = ps2_clk_prev & ~ps2_clk_synced;

    // --- State Machine ---
    parameter IDLE = 0;
    parameter RECEIVING = 1;
    parameter CHECK_STOP = 2; // Added state for clarity

    reg [1:0] state;
    reg [3:0] bit_count;
    reg [7:0] data_buffer;
    reg parity_bit;
    reg error_flag; // Optional: Flag framing/parity errors

    // --- Initialization ---
    initial begin
        state = IDLE;
        bit_count = 0;
        data_buffer = 0;
        parity_bit = 0;
        data = 0;
        // data_valid = 0;
        error_flag = 0;
        ps2_clk_prev = 1; // Assume idle high
    end

    // --- Reception Logic (driven by system clock, triggered by edge detector) ---
    always @(posedge clk) begin
        // Default assignment for data_valid (ensure it's normally low)
        // data_valid <= 0;
        // error_flag <= 0; // Reset error flag if needed

        if (ps2_clk_falling_edge) begin
            case (state)
                IDLE: begin
                    if (ps2_dat_synced == 0) begin // Check for START bit (must be 0)
                        state <= RECEIVING;
                        bit_count <= 0;
                        data_buffer <= 0; // Clear buffer
                        error_flag <= 0; // Clear error
                    end
                    // else: Stay in IDLE, ignore falling edge if data isn't low (noise or bus idle)
                end

                RECEIVING: begin
                    if (bit_count < 8) begin // Data bits 0-7 (LSB first)
                        data_buffer[bit_count] <= ps2_dat_synced; // Store bit
                        bit_count <= bit_count + 1;
                    end else if (bit_count == 8) begin // Parity bit
                        parity_bit <= ps2_dat_synced;
                        bit_count <= bit_count + 1;
                        state <= CHECK_STOP; // Move to check stop bit on next edge
                    end
                    // Should not happen, but reset if count gets too high
                    else begin
                         state <= IDLE;
                         error_flag <= 1; // Indicate error
                    end
                end

                CHECK_STOP: begin
                    if (ps2_dat_synced == 1) begin // Check for STOP bit (must be 1)
                        // Successful reception
                        data <= data_buffer; // Update output register
                        // data_valid <= 1;         // Signal data is valid for one cycle
                        // Optional: Add parity check here:
                        // if ({parity_bit, data_buffer} % 2 != 1) error_flag <= 1; // Odd parity check
                    end else begin
                        // Framing error (Stop bit is not 1)
                        error_flag <= 1; // Indicate error
                        // Do not assert data_valid or update data_out
                    end
                    state <= IDLE; // Go back to idle regardless of stop bit correctness
                    bit_count <= 0; // Reset count
                end

                default: begin // Should not happen
                   state <= IDLE;
                end
            endcase // case (state)
        end // if (ps2_clk_falling_edge)
    end // always @ (posedge clk)

endmodule
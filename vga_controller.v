module vga_controller(
    input wire clk,               // 25 MHz clock
    input wire reset,             // System reset
    // CPU interface
    input wire mem_write,         // Write enable from CPU
    input wire [15:0] address,    // Memory address from CPU
    input wire [7:0] write_data,  // Data to write from CPU
    output wire [7:0] read_data,  // Data to read by CPU
    // VGA outputs
    output wire hsync,
    output wire vsync,
    output wire [2:0] rgb,        // Simplified to 3 bits (1 bit per color)
    output wire video_on,         // Signal indicating if the current pixel is within the visible area
    output wire [9:0] pixel_x,    // Current pixel X coordinate
    output wire [9:0] pixel_y     // Current pixel Y coordinate
);

// Horizontal parameters (800 pixels total)
parameter horiz_sync_pulse = 96;
parameter horiz_back_porch = 48;
parameter horiz_display = 640;
parameter horiz_front_porch = 16;
parameter horiz_total = 800;

// Vertical parameters (525 lines total)
parameter vert_sync_pulse = 2;
parameter vert_back_porch = 33;
parameter vert_display = 480;
parameter vert_front_porch = 10;
parameter vert_total = 525;

// Registers to hold the current position
reg [9:0] h_count = 0;
reg [9:0] v_count = 0;

// Frame buffer memory (simplified 80x60 grid with 8-bit color)
// Each cell is 8x8 pixels for easier CPU management
reg [7:0] frame_buffer[0:4799]; // 80x60 = 4800 cells

// Horizontal and vertical sync signals, active low
assign hsync = (h_count < horiz_sync_pulse) ? 0 : 1;
assign vsync = (v_count < vert_sync_pulse) ? 0 : 1;

// Calculate if the current pixel is within the visible area
assign video_on = (h_count < horiz_display) && (v_count < vert_display);
assign pixel_x = h_count < horiz_display ? h_count : 0;
assign pixel_y = v_count < vert_display ? v_count : 0;

// Calculate the frame buffer address based on pixel coordinates
wire [11:0] buffer_addr = ((pixel_y >> 3) * 80) + (pixel_x >> 3);
wire [7:0] pixel_color = frame_buffer[buffer_addr];

// RGB output - display color from frame buffer
assign rgb = video_on ? pixel_color[2:0] : 3'b000;

// Memory interface for CPU
assign read_data = (address < 16'd4800) ? frame_buffer[address] : 8'h00;

// CPU write to frame buffer
always @(posedge clk) begin
    if (reset) begin
        integer i;
        for (i = 0; i < 4800; i = i + 1)
            frame_buffer[i] <= 8'h00;
    end
    else if (mem_write && address < 16'd4800) begin
        frame_buffer[address] <= write_data;
    end
end

// Horizontal counter
always @(posedge clk) begin
    if (reset)
        h_count <= 0;
    else if (h_count == horiz_total - 1)
        h_count <= 0;
    else
        h_count <= h_count + 1;
end

// Vertical counter
always @(posedge clk) begin
    if (reset)
        v_count <= 0;
    else if (h_count == horiz_total - 1) begin
        if (v_count == vert_total - 1)
            v_count <= 0;
        else
            v_count <= v_count + 1;
    end
end

endmodule
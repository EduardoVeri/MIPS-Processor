module vga_controller(
    input wire clk,  // 25 MHz clock
    output wire hsync,
    output wire vsync,
    output wire [2:0] rgb,  // Simplified to 3 bits (1 bit per color)
    output wire video_on,  // Signal indicating if the current pixel is within the visible area
    output wire [9:0] pixel_x,  // Current pixel X coordinate
    output wire [9:0] pixel_y   // Current pixel Y coordinate
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

// Horizontal and vertical sync signals, active low
assign hsync = (h_count < horiz_sync_pulse) ? 0 : 1;
assign vsync = (v_count < vert_sync_pulse) ? 0 : 1;

// RGB output - let's display a simple pattern based on the pixel position
assign rgb = (video_on) ? ((pixel_x[6] ^ pixel_y[6]) ? 3'b111 : 3'b000) : 3'b000;

// Calculate if the current pixel is within the visible area
assign video_on = (h_count < horiz_display) && (v_count < vert_display);
assign pixel_x = h_count < horiz_display ? h_count : 0;
assign pixel_y = v_count < vert_display ? v_count : 0;

// Horizontal counter
always @(posedge clk) begin
    if (h_count == horiz_total - 1)
        h_count <= 0;
    else
        h_count <= h_count + 1;
end

// Vertical counter
always @(posedge clk) begin
    if (h_count == horiz_total - 1) begin
        if (v_count == vert_total - 1)
            v_count <= 0;
        else
            v_count <= v_count + 1;
    end
end

endmodule
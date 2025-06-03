module VGA (
    input wire clock,         // System clock (e.g., 50 MHz)
    input wire wr_en,         // Write enable for framebuffer
    input wire [16:0] wr_addr, // Write address for framebuffer (original width)
    input wire [2:0] wr_data,  // Write data for framebuffer
    output wire [2:0] disp_RGB,// RGB data to display
    output wire hsync,        // Horizontal sync
    output wire vsync         // Vertical sync
);

    // Parameter to control pixel scaling.
    // PIXEL_SCALING_FACTOR = 1: Original 320x240 logical FB (each FB pixel is 2x2 screen pixels)
    // PIXEL_SCALING_FACTOR = 2: New 160x120 logical FB (each FB pixel is 4x4 screen pixels)
    // PIXEL_SCALING_FACTOR = 4: New 80x60 logical FB (each FB pixel is 8x8 screen pixels)
    // Ensure 320 and 240 are divisible by this factor.
    parameter PIXEL_SCALING_FACTOR = 8;

    // Original logical framebuffer dimensions (before this new scaling factor)
    localparam ORIGINAL_FB_LOGICAL_WIDTH = 320;
    localparam ORIGINAL_FB_LOGICAL_HEIGHT = 240;

    // New actual framebuffer dimensions after applying PIXEL_SCALING_FACTOR
    localparam ACTUAL_FB_WIDTH = ORIGINAL_FB_LOGICAL_WIDTH / PIXEL_SCALING_FACTOR;
    localparam ACTUAL_FB_HEIGHT = ORIGINAL_FB_LOGICAL_HEIGHT / PIXEL_SCALING_FACTOR;
    localparam ACTUAL_FB_ADDR_WIDTH = $clog2(ACTUAL_FB_WIDTH * ACTUAL_FB_HEIGHT); 

    // Sanity check for PIXEL_SCALING_FACTOR
    initial begin
        if (ORIGINAL_FB_LOGICAL_WIDTH % PIXEL_SCALING_FACTOR != 0 || ORIGINAL_FB_LOGICAL_HEIGHT % PIXEL_SCALING_FACTOR != 0) begin
            $display("Error: PIXEL_SCALING_FACTOR (%0d) does not evenly divide original FB dimensions (320x240).", PIXEL_SCALING_FACTOR);
            $finish;
        end
        if (PIXEL_SCALING_FACTOR < 1) begin
            $display("Error: PIXEL_SCALING_FACTOR must be 1 or greater.");
            $finish;
        end
         $display("VGA Scaled Pixels: PIXEL_SCALING_FACTOR = %0d", PIXEL_SCALING_FACTOR);
         $display("New Framebuffer Dimensions: %0d x %0d", ACTUAL_FB_WIDTH, ACTUAL_FB_HEIGHT);
         $display("New Framebuffer Address Width: %0d bits", ACTUAL_FB_ADDR_WIDTH);
    end

    reg [9:0] hcount, vcount; // Horizontal and vertical screen counters (pixel clock rate)
    wire hcount_ov, vcount_ov, dat_act;
    reg vga_clk; // VGA pixel clock (e.g., 25 MHz)

    // Framebuffer signals
    wire [ACTUAL_FB_ADDR_WIDTH-1:0] rd_addr_internal; // Read address for the new smaller framebuffer
    wire [2:0] fb_data;          // Data read from framebuffer

    // Timing parameters (standard 640x480 @ 60Hz, pixel clock ~25MHz)
    // hcount values are based on the vga_clk (pixel clock)
    parameter hsync_end  = 10'd95,    // End of HSync pulse (pulse width 96 clocks)
              hdat_begin = 10'd143,   // Start of active horizontal display (after front porch)
                                      // HSync pulse (96) + Back Porch (48) = 144. Start at 144th clock cycle (index 143)
              hdat_end   = 10'd783,   // End of active horizontal display (640 pixels: 143 + 640 = 783)
              hpixel_end = 10'd799;   // Total horizontal pixels per line (800)

    parameter vsync_end  = 10'd1,     // End of VSync pulse (pulse width 2 lines)
              vdat_begin = 10'd34,    // Start of active vertical display (after front porch)
                                      // VSync pulse (2) + Back Porch (33) = 35. Start at 35th line (index 34)
              vdat_end   = 10'd514,   // End of active vertical display (480 lines: 34 + 480 = 514)
              vline_end  = 10'd524;   // Total vertical lines per frame (525)

    // ============= TEST - Writing to framebuffer (Updated for new dimensions) ===================
    // This test pattern generator writes to a conceptual framebuffer.
    // If you want this to write to fb2, you'd need to mux its outputs
    // with the primary wr_en, wr_addr, wr_data inputs of the VGA module.

    integer new_clock_divider_test = 0; // Renamed to avoid conflict if 'new_clock' is used elsewhere
    reg test_vga_clk = 0; // Clock for test pattern generation
    integer clk_div_test = 0;

    always @(posedge clock) begin
        if (clk_div_test == 50000) begin // Arbitrary slow clock for test writing
            test_vga_clk <= ~test_vga_clk;
            clk_div_test <= 0;
        end else begin
            clk_div_test <= clk_div_test + 1;
        end
    end

    reg [ACTUAL_FB_ADDR_WIDTH-1:0] reg_wr_addr_internal; // Address for test write, sized for new FB
    reg [2:0] reg_wr_data_internal;
    reg reg_wr_en_internal;
    reg [2:0] pixel_colors_test;

    initial begin
        reg_wr_en_internal = 0;
        reg_wr_addr_internal = 0;
        reg_wr_data_internal = 0;
        pixel_colors_test = 3'h0;
    end

    // Counter for test pattern address
    reg [$clog2(ACTUAL_FB_WIDTH * ACTUAL_FB_HEIGHT)-1:0] pixel_addr_test_counter = 0;
    always @(posedge test_vga_clk) begin
        reg_wr_en_internal <= 0;
        reg_wr_addr_internal <= pixel_addr_test_counter;
        reg_wr_data_internal <= pixel_colors_test;
        
        if (pixel_addr_test_counter == (ACTUAL_FB_WIDTH * ACTUAL_FB_HEIGHT - 1)) begin
            pixel_addr_test_counter <= 0;
        pixel_colors_test <= pixel_colors_test + 1; // Cycle color per full frame write
        end else begin
            pixel_addr_test_counter <= pixel_addr_test_counter + 1;
        end
        // To make colors change faster within a frame for testing:
        // pixel_colors_test <= pixel_colors_test + 1; 
    end
    // ============= END TEST - Writing to framebuffer ===================

    // Instantiate framebuffer
    // Note: ADDR_WIDTH is now ACTUAL_FB_ADDR_WIDTH.
    // The input wr_addr to this VGA module is [16:0]. We truncate it for the smaller framebuffer.
    // The external system providing wr_addr MUST ensure it's within the range of the new smaller framebuffer.
    framebuffer #(
        .DATA_WIDTH(3),
        .ADDR_WIDTH(ACTUAL_FB_ADDR_WIDTH)
    ) fb2 (
        .clk(vga_clk), // Use the VGA pixel clock for framebuffer operations
        .we(reg_wr_en_internal),
        .write_addr(reg_wr_addr_internal[ACTUAL_FB_ADDR_WIDTH-1:0]), // Use lower bits of wr_addr
        .data(reg_wr_data_internal),
        .read_addr(rd_addr_internal),
        .q(fb_data)
    );

    // Read address calculation
    // hcount and vcount are screen pixel/line counters (0-799, 0-524)
    // (hcount - hdat_begin) gives 0-639 for active horizontal display
    // (vcount - vdat_begin) gives 0-479 for active vertical display

    wire [9:0] screen_h_coord = (hcount >= hdat_begin && hcount < hdat_end) ? (hcount - hdat_begin) : 0;
    wire [9:0] screen_v_coord = (vcount >= vdat_begin && vcount < vdat_end) ? (vcount - vdat_begin) : 0;

    // These are coordinates for the original 320x240 logical grid,
    // where each such "pixel" is 2x2 actual screen pixels.
    wire [9:0] logical_h_coord_320 = screen_h_coord / 2; // Results in 0-319
    wire [9:0] logical_v_coord_240 = screen_v_coord / 2; // Results in 0-239

    // These are the coordinates for the new, smaller, actual framebuffer.
    // Each of these actual framebuffer pixels will be scaled up.
    wire [9:0] fb_access_h_idx = logical_h_coord_320 / PIXEL_SCALING_FACTOR;
    wire [9:0] fb_access_v_idx = logical_v_coord_240 / PIXEL_SCALING_FACTOR;

    // Calculate the 1D address for the framebuffer
    assign rd_addr_internal = fb_access_v_idx * ACTUAL_FB_WIDTH + fb_access_h_idx;

    // Clock divider for VGA pixel clock (e.g., 50MHz system clock to 25MHz VGA clock)
    always @(posedge clock) begin
        vga_clk <= ~vga_clk;
    end

    // Horizontal counter (counts at vga_clk rate)
    always @(posedge vga_clk) begin
        if (hcount_ov) hcount <= 10'd0;
        else hcount <= hcount + 10'd1;
    end
    assign hcount_ov = (hcount == hpixel_end);

    // Vertical counter (increments when a horizontal line ends)
    always @(posedge vga_clk) begin
        if (hcount_ov) begin // Only increment vcount at the end of a horizontal line
            if (vcount_ov) vcount <= 10'd0;
            else vcount <= vcount + 10'd1;
        end
    end
    assign vcount_ov = (vcount == vline_end);

    // Sync signals and active data region
    // dat_act is true when hcount and vcount are within the active display area
    assign dat_act = ((hcount >= hdat_begin) && (hcount < hdat_end))
                  && ((vcount >= vdat_begin) && (vcount < vdat_end));

    // HSync and VSync signals. Polarity might need to be inverted depending on monitor.
    // Typically, sync signals are active low. The current logic generates active high.
    // For active low: assign hsync = ~(hcount <= hsync_end && hcount > 0);
    // For active low: assign vsync = ~(vcount <= vsync_end && vcount > 0);
    // The provided original code implies active high for hsync when hcount > hsync_end.
    // Standard VGA: HSync is low during sync pulse, high otherwise.
    // Standard VGA: VSync is low during sync pulse, high otherwise.
    // hsync_end is the end of the sync pulse. So, hcount should be < hsync_end for active sync.
    // Let's assume standard active-low for typical monitors.
    assign hsync = !((hcount >= 0) && (hcount < hsync_end)); // Active low during pulse
    assign vsync = !((vcount >= 0) && (vcount < vsync_end)); // Active low during pulse


    // RGB output: display framebuffer data during active region, else black
    assign disp_RGB = dat_act ? fb_data : 3'h0;

endmodule
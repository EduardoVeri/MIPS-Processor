module VGA(input wire clock,
           input wire wr_en,
           input wire [16:0] wr_addr,
           input wire [2:0] wr_data,
           output wire [2:0] disp_RGB,
           output wire hsync,
           output wire vsync);
    
    reg [9:0] hcount, vcount;
    wire hcount_ov, vcount_ov, dat_act;
    reg vga_clk;
    
    // Framebuffer signals
    wire [16:0] rd_addr;
    wire [2:0] fb_data;
    
    // Timing parameters (unchanged)
    parameter hsync_end = 10'd95,
        hdat_begin = 10'd143,
        hdat_end = 10'd783,
        hpixel_end = 10'd799,
        vsync_end = 10'd1,
        vdat_begin = 10'd34,
        vdat_end = 10'd514,
        vline_end = 10'd524;
    
    // ============= TEST - Writing to framebuffer ===================

    integer new_clock = 0;
    integer clk_div = 0;
    always @(posedge clock) begin
        if (clk_div == 50000) begin
            new_clock <= ~new_clock; // Toggle VGA clock every 50,000 cycles
            clk_div <= 0;
        end else begin
            clk_div <= clk_div + 1;
        end
    end

    reg [16:0] reg_wr_addr;
    reg [2:0] reg_wr_data;
    reg reg_wr_en;
    reg [2:0] pixel_colors;

    initial begin
        reg_wr_en = 0;
        reg_wr_addr = 0;
        reg_wr_data = 0;
        pixel_colors = 3'h0; // Initialize pixel colors
    end

    integer pixel_addr = 0;
    always @(posedge new_clock) begin
        reg_wr_en <= 1;
        reg_wr_addr <= pixel_addr;
        reg_wr_data <= pixel_colors;
        pixel_addr <= pixel_addr + 1;
        pixel_colors <= pixel_colors + 1; // Cycle through colors
        if (pixel_addr == 320 * 240 - 1) begin
            pixel_addr <= 0; // Reset pixel address after filling the framebuffer
        end
    end
    
    // Instantiate framebuffer
    framebuffer fb (
        .clk(vga_clk),
        .we(reg_wr_en),
        .write_addr(reg_wr_addr),
        .data(reg_wr_data),
        .read_addr(rd_addr),
        .q(fb_data)
    );

    // ============= END TEST - Writing to framebuffer ===================

    // framebuffer fb2 (
    //     .clk(vga_clk),
    //     .we(wr_en),
    //     .write_addr(wr_addr),
    //     .data(wr_data),
    //     .read_addr(rd_addr),
    //     .q()
    // );

    
    wire [9:0] scaled_hcount = (hcount - hdat_begin) / 2; // Get 0-319 range from 0-639 hcount
    wire [9:0] scaled_vcount = (vcount - vdat_begin) / 2; // Get 0-239 range from 0-479 vcount
    
    // Read address calculation
    assign rd_addr = scaled_vcount * 320 + scaled_hcount;
    
    // Clock divider (25 MHz for 50 MHz input)
    always @(posedge clock) begin
        vga_clk <= ~vga_clk;
    end
    
    // Horizontal counter
    always @(posedge vga_clk) begin
        if (hcount_ov)
            hcount <= 10'd0;
        else
            hcount <= hcount + 10'd1;
    end
    assign hcount_ov = (hcount == hpixel_end);
    
    // Vertical counter
    always @(posedge vga_clk) begin
        if (hcount_ov) begin
            if (vcount_ov)
                vcount <= 10'd0;
            else
                vcount <= vcount + 10'd1;
        end
    end
    assign vcount_ov = (vcount == vline_end);
    
    // Sync signals and active region
    assign dat_act = ((hcount >= hdat_begin) && (hcount < hdat_end))
    && ((vcount >= vdat_begin) && (vcount < vdat_end));
    assign hsync  = (hcount > hsync_end);  // Verify polarity!
    assign vsync  = (vcount > vsync_end);  // Verify polarity!
    
    // RGB output (framebuffer data)
    assign disp_RGB = dat_act ? fb_data : 3'h0;
    
endmodule

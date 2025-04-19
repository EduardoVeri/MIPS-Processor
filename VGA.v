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
    hdat_begin = 10'd239,
    hdat_end = 10'd559,
    hpixel_end = 10'd799,
    vsync_end = 10'd1,
    vdat_begin = 10'd144,
    vdat_end = 10'd384,
    vline_end = 10'd524;
    
    // Instantiate framebuffer
    framebuffer fb (
    .clk(vga_clk),
    .we(wr_en),
    .write_addr(wr_addr),
    .data(wr_data),
    .read_addr(rd_addr),
    .q(fb_data)
    );
    
    // Read address calculation
    assign rd_addr = (vcount - vdat_begin) * 320 + (hcount - hdat_begin);
    
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
    assign dat_act = ((hcount > = hdat_begin) && (hcount < hdat_end))
    && ((vcount > = vdat_begin) && (vcount < vdat_end));
    assign hsync  = (hcount > hsync_end);  // Verify polarity!
    assign vsync  = (vcount > vsync_end);  // Verify polarity!
    
    // RGB output (framebuffer data)
    assign disp_RGB = dat_act ? fb_data : 3'h00;
    
endmodule

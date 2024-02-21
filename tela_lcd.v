module tela_LCD(clock_50, Switches, LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS, LCD_DATA, Immediate, clock, EnableDisplay, Data1, Data2);

	input clock_50;
	input clock;
	input EnableDisplay;
	input [15:0] Immediate;
	input [17:0] Switches;
	input [31:0] Data1, Data2;
	
	output LCD_ON;	// LCD Power ON/OFF
	output LCD_BLON;	// LCD Back Light ON/OFF
	output LCD_RW;	// LCD Read/Write Select, 0 = Write, 1 = Read
	output LCD_EN;	// LCD Enable
	output LCD_RS;
	inout [7:0] LCD_DATA;
	
	wire [3:0] ThousandsBin1;
	wire [3:0] HundredsBin1;
	wire [3:0] TensBin1;
	wire [3:0] OnesBin1;
	
	wire [3:0] ThousandsBin2;
	wire [3:0] HundredsBin2;
	wire [3:0] TensBin2;
	wire [3:0] OnesBin2;
	
	reg [15:0] Choice;
	reg [31:0] RegData1, RegData2;
	
	always @ (negedge clock) begin
		if(EnableDisplay) begin
			Choice = Immediate;
			RegData1 = Data1;
			RegData2 = Data2;
		end
	end 
	
	BCD bcd1(RegData1[12:0], ThousandsBin1, HundredsBin1, TensBin1, OnesBin1);
	BCD bcd2(RegData2[12:0], ThousandsBin2, HundredsBin2, TensBin2, OnesBin2);
	
	lcdlab3 lcd(clock_50, 1'b0, Choice, ThousandsBin1, HundredsBin1, TensBin1, OnesBin1, 
					ThousandsBin2, HundredsBin2, TensBin2, OnesBin2, GPIO_0, GPIO_1, LCD_ON, LCD_BLON, LCD_RW, 
					LCD_EN, LCD_RS, LCD_DATA);
	
endmodule

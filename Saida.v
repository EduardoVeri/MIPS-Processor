module Saida (
	input [31:0] ValorSaida,
	input halt, Clock, EnableOut, EnableIn,
	output [13:0] Led,
	output [6:0] Display1, Display2, Display3, Display4, DisplayRef, Display6, Display_FP1, Display_FP2,
	input [9:0] PC,
	input [31:0] FP
	
);

	reg[31:0] valorDisplay1, valorDisplay2, valorDisplay3, valorDisplay4, valorDisplayRef, valorDisplay6, valorDisplayFP1, valorDisplayFP2;
	reg regLed13; // Trocar por um verde
	reg [12:0] RegLeds;
	integer contador1 = 1;
	integer contador2 = 1;
	
	initial begin
		valorDisplay1 = 4'b1110;
		valorDisplay2 = 4'b1110;
		valorDisplay3 = 4'b1110;
		valorDisplay4 = 4'b1110;
	end
	
	always @(negedge Clock) begin
		
		if(Clock) begin
		;
		end
		
		valorDisplayFP1 = FP%10;
		valorDisplayFP2 = (FP%100)/10;
		
		
		if(contador1 == 1) begin
			valorDisplay1 = 4'b1110;
			valorDisplay2 = 4'b1110;
			valorDisplay3 = 4'b1110;
			valorDisplay4 = 4'b1110;
			contador1 = 0;
		end
		else begin
			if(EnableOut) begin
				valorDisplay1 = ValorSaida%10;
				valorDisplay2 = (ValorSaida%100)/10;
				valorDisplay3 = (ValorSaida%1000)/100;
				valorDisplay4 = (ValorSaida%10000)/1000;
			end
		end
	end
	
	
	always @(*)
	begin
		if(halt == 1) begin
			valorDisplayRef = 4'b1111;
			valorDisplay6 = 4'b1111;
			regLed13 = 1;
		end
		else begin
			valorDisplay6 = PC%10;
			valorDisplayRef = (PC%100)/10;
			regLed13 = 0;
		end
		
		if(contador2) begin
			RegLeds = 13'd0;
			contador2 = 0;
		end
		if(EnableIn)
			RegLeds = ValorSaida;

	
	end
	
	Contato1 bcd1 (valorDisplay1, Display1, Clock);
	Contato1 bcd2 (valorDisplay2, Display2, Clock);
	Contato1 bcd3 (valorDisplay3, Display3, Clock);
	Contato1 bcd4 (valorDisplay4, Display4, Clock);
	Contato1 bcd5 (valorDisplayRef, DisplayRef, Clock);
	Contato1 bcd6 (valorDisplay6, Display6, Clock);
	Contato1 bcd7 (valorDisplayFP1, Display_FP1, Clock);
	Contato1 bcd8 (valorDisplayFP2, Display_FP2, Clock);
	
	assign Led = {regLed13, RegLeds[12:0]};
	
endmodule 
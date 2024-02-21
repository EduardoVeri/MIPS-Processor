module MultiplexadorALUSrc (
	input [31:0] Imediato, 
	input [31:0] BR_Dado2,
	input ALUSrc,
	output [31:0] Escolhido_MultiplexadorALUSrc
);
	
	reg [31:0] escolhido;
	
	always @(Imediato or BR_Dado2 or ALUSrc) begin
	
		if(ALUSrc == 1) begin
			escolhido = Imediato;
		end
		
		else begin
			escolhido = BR_Dado2;
		end
		
	end
	
	assign Escolhido_MultiplexadorALUSrc = escolhido;
	
endmodule

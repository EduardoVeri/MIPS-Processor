module MultiplexadorSaida(
	input [13:0] DadoLido_Entrada, 
	input [31:0] Resultado_ULA,
	input In, Out,
	output [31:0] Escolhido_MultiplexadorSaida
);
	
	reg [31:0] escolhido;
	
	always @(*) begin
	
		if(In == 1) begin
			escolhido = {18'd0, DadoLido_Entrada};
		end
		
		else if(Out == 1) begin
			escolhido = Resultado_ULA;
		end
		
	end
	
	assign Escolhido_MultiplexadorSaida = escolhido;
	
endmodule

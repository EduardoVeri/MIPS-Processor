module MultiplexadorDestino(
	input [4:0] RegDestino, 
	input JAL, JALR,
	output [4:0] EscolhidoMultiplexadorDestino
);
	
	reg [4:0] escolhido;
	
	always @(*) begin
		if(JAL == 1)
			escolhido = 5'd30;
		else if (JALR == 1)
			escolhido = 5'd30;
		else begin
			escolhido = RegDestino;
		end
		
	end
	
	assign EscolhidoMultiplexadorDestino = escolhido;
	
endmodule

module MultiplexadorEntrada (
	input [13:0] DadoLido_Entrada, 
	input [31:0] Dado_MemoriaULA,
	input In,
	output [31:0] Escolhido_MultiplexadorEntrada
);
	
	reg [31:0] escolhido;
	
	always @(*) begin
	
		if(In == 1) begin
			escolhido = {18'd0, DadoLido_Entrada};
		end
		
		else begin
			escolhido = Dado_MemoriaULA;
		end
		
	end
	
	assign Escolhido_MultiplexadorEntrada = escolhido;
	
endmodule

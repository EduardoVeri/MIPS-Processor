module MultiplexadorEntrada (
	input [13:0] DadoLido_Entrada, 
	input [31:0] Dado_MemoriaULA,
	input [7:0] KeyboardInput,
	input [1:0] In, // 0 - Dado_MemoriaULA, 1 - DadoLido_Entrada, 2 - KeyboardInput,
	output [31:0] Escolhido_MultiplexadorEntrada
);
	
	reg [31:0] escolhido;
	
	always @(*) begin
	
		if(In == 1) begin
			escolhido = {18'd0, DadoLido_Entrada};
		end
		else if (In == 2) begin
			escolhido = {24'd0, KeyboardInput};
		end
		else begin
			escolhido = Dado_MemoriaULA;
		end
		
	end
	
	assign Escolhido_MultiplexadorEntrada = escolhido;
	
endmodule

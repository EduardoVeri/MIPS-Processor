module MultiplexadorMemtoReg (
	input [31:0] DadoLido_Mem, 
	input [31:0] Resultado_ULA,
	input MemtoReg,
	output [31:0] Escolhido_MultiplexadorMemtoReg
);
	
	reg [31:0] escolhido;
	
	always @(MemtoReg or DadoLido_Mem or Resultado_ULA) begin
	
		if(MemtoReg == 1) begin
			escolhido = DadoLido_Mem;
		end
		
		else begin
			escolhido = Resultado_ULA;
		end
		
	end
	
	assign Escolhido_MultiplexadorMemtoReg = escolhido;
	
endmodule

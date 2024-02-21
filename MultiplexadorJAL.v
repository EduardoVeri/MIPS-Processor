module MultiplexadorJAL (
	input [10:0] ProximoPC, 
	input [31:0] EscolhidoMemToReg,
	input JALR, JUMPAL,
	output [31:0] Escolhido_MultiplexadorJAL
);
	
	reg [31:0] escolhido;
	
	always @ (*) begin
		
		
		if(JALR == 1 || JUMPAL == 1) begin
			escolhido = {21'd0, ProximoPC};
		end
		
		else begin
			escolhido = EscolhidoMemToReg;
		end
		
	end
	
	assign Escolhido_MultiplexadorJAL = escolhido;
	
endmodule

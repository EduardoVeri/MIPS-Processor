module MultiplexadorJumpReg (
	input [31:0] Dado1, 
	input [10:0] Jump,
	input JALR, JReg,
	output [10:0] Escolhido_MultiplexadorJumpReg
);
	
	reg [10:0] escolhido;
	
	always @ (*) begin
		
		if(JALR == 1 || JReg == 1) begin
			escolhido = Dado1[10:0];
		end
		
		else begin
			escolhido = Jump;
		end
		
	end
	
	assign Escolhido_MultiplexadorJumpReg = escolhido;
	
endmodule

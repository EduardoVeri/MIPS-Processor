module MultiplexadorRegDst(
	input [4:0] RegT, 
	input [4:0] RegD,
	input RegDst,
	output [4:0] Escolhido_MultiplexadorRegDst
);
	
	reg [4:0] escolhido;
	
	always @(*) begin
	
		if(RegDst == 1) begin
			escolhido = RegT;
		end
		
		else begin
			escolhido = RegD;
		end
		
	end
	
	assign Escolhido_MultiplexadorRegDst = escolhido;
	
endmodule

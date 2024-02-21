
module BNEandBEQ (
	input ControlBEQ, ControlBNE, Zero,
	output Control_Branch
);
	
	reg resultadoBEQ, resultadoBNE, resultado;
	
	always @(*) begin 
		
		resultadoBEQ = Zero & ControlBEQ;
		resultadoBNE = ~Zero & ControlBNE;
		resultado = resultadoBEQ | resultadoBNE;
	end
	
	assign Control_Branch = resultado;
		
endmodule


module Jump(
	input [25:0] Imediato26bits,
	input JumpContext,
	input [31:0] Imediato,
	output [31:0] Instrucao
);
	reg [31:0] RegImediato;
	reg [10:0] Valor_JumpContext;

	always @(*) begin
		/*if(JumpContext == 1) begin
			Valor_JumpContext = Imediato[10:0];
		end
		else begin*/
			// Caso precise extender, fazer aqui!
			RegImediato = {6'b0, (Imediato26bits /*+ {15'd0, Valor_JumpContext}*/)};
		//end
		
		
	end

	assign Instrucao = RegImediato;
	
endmodule
	
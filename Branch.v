module Branch(
    input [31:0] Imediato,
    input [10:0] PCAtual,
    input MuxBranch, JumpContext,
    output [10:0] NovoEndereco,
	output [10:0] Valor
);

    reg [10:0] InstrucaoModificada;
    reg [10:0] Valor_JumpContext = 11'b0; // Inicialize com zero.

    always @(*) begin
       /* if (JumpContext == 1) begin
        //    Valor_JumpContext = Imediato[10:0];
        end else */ 
		if (MuxBranch == 1) begin
            InstrucaoModificada = Imediato; //+ {21'd0, Valor_JumpContext};
        end else begin
            InstrucaoModificada = PCAtual + 1;
        end
	end

    assign NovoEndereco = InstrucaoModificada[10:0];
	assign Valor = Valor_JumpContext;

endmodule

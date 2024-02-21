
module CPU(
	input EntradaClock,
	//input ClockTeste,
	input [13:0] Sw,
	input Botao,
	output [6:0] Display1, Display2, Display3, Display4, DisplayRef, Display6, Display_FP1, Display_FP2,
	output [13:0] Led,
	output LedVerde,
	output LCD_ON,	// LCD Power ON/OFF
	output LCD_BLON,	// LCD Back Light ON/OFF
	output LCD_RW,	// LCD Read/Write Select, 0 = Write, 1 = Read
	output LCD_EN,	// LCD Enable
	output LCD_RS,
	inout [7:0] LCD_DATA
);	
	
	/*
		Aqui serão colocadas todas os fios de saída dos módulos,
		para que sejam usados para interconectá-los
	*/
	reg [31:0] Imediato_extendido;
	reg [31:0] Proxima_Intrucao;
	
	// Saida Unidade de Controle
	wire RegWrite, MemtoReg, MemRead, MemWrite, ALUSrc, 
		RegDst, PCFunct, ControlJump, BEQ, BNE, Halt, In, 
		Out, EnableClock, JAL, EnableDisp, savePC, JumpContextJump,
		savePCBuffer, setClock, getInterruption;
	wire [2:0] ALUOp;
	
	//Saida Unidade de Controle da ULA
	wire [3:0] Control_ALU;
	wire JALR, JR;
	
	// Saida ULA
	wire [31:0] Saida_ULA;
	wire Zero;
	
	// Saída Banco Registradores
	wire [31:0] BR_Dado1, BR_Dado2, ResultadoEscritaBanco;
	
	// Saída Memória RAM
	wire [31:0] DadoMemoriaRAM;
	
	// Saída Multiplexador MemToReg
	wire [31:0] Escolhido_MultiplexadorMemtoReg;
	
	// Saída Multiplexador ALUSrc
	wire [31:0] Escolhido_MultiplexadorALUSrc;
	
	// Saída Multiplexador RegDst
	wire [4:0] EscolhidoMultiplexadorRegDst;
	
	// Saida PC
	wire [10:0] EnderecoInstrucao;
	
	// Saida ROM
	wire [31:0] Instrucao;
	
	// Saida Modulo de Branch
	wire [10:0] NovoEndereco;
	
	// Saida Modulo de Jump
	wire [31:0] EnderecoDoJump;
	
	// Saida Multiplexador Jump
	wire [10:0] Escolhido_MultiplexadorJump;
	
	// Saida BNEandBEQ
	wire ControlBranch;
	
	// Saida Entrada
	wire [13:0] resultadoEntrada;
	wire saidaBotao;
	wire Clock;
	
	//Saida Multiplexador Entrada
	wire [31:0] EscolhidoMultiplexadorEntrada;
	
	//Saida Multiplexador Saida
	wire [31:0] EsolhidoMultiplexadorSaida;
	
	//Saida Multiplexador JAL JALR para o BR
	wire [4:0] EscolhidoMultiplexadorDestino;
	
	//Saida Multiplexador JAL com o valor armazenado do PC 
	wire [10:0] Escolhido_MultiplexadorJAL;
	
	//Saida Multiplexador JReg e JALR, direcionando o valor do banco de Reg para o PC
	wire [10:0] Escolhido_MultiplexadorJumpReg;
	
	// Saida Multiplexador entre valor da entrada e o valor atual do PC
	wire [31:0] Escolhido_MultiplexadorPC;
	
	// Valor do Frame Pointer
	wire [31:0] FP;

	// Saida Interrupção
	wire int_halt, int_clk;
	
	// Extensor de Imediato
	always @(Instrucao[15:0]) begin
		Imediato_extendido = {16'b0000000000000000, Instrucao[15:0]};
	end
	
	reg [13:0] resultadoSomaEntrada;
	
	integer inteiroContagem = 1;
	
	wire [10:0] extra;

	reg [10:0] novoValorPC;

	reg [31:0] qualInterrupcao;
	reg [10:0] bufferPC;

	always @(posedge Clock) begin
		if (inteiroContagem) begin
			inteiroContagem = 0;
			qualInterrupcao = 32'd0;
			bufferPC = 11'd0;
		end

		if (int_halt) begin
			qualInterrupcao = 32'd2;
		end
		else if (int_clk) begin
			qualInterrupcao = 32'd1;
		end

		if(getInterruption) begin
			qualInterrupcao = 32'd0;
		end

		if (int_clk) begin
			bufferPC = Escolhido_MultiplexadorJumpReg;
		end
	end

	/*
	 	Esse bloco é responsável por verificar se o halt foi ativado,
		caso tenha sido, o valor do PC será 0, caso contrário, será o
		valor do multiplexador de jump
	*/
	always @(*) begin
		if (int_halt || int_clk) begin
			novoValorPC = 11'd0;
		end
		else begin
			novoValorPC = Escolhido_MultiplexadorJumpReg;
		end
	end

	assign Led[13] = In;
	assign LedVerde = Clock;
	
	Saida exit (EsolhidoMultiplexadorSaida[12:0], Halt, Clock, Out, In,Led[12:0], Display1, 
		Display2, Display3, Display4, DisplayRef, Display6, Display_FP1, Display_FP2, 
		EnderecoInstrucao, FP);
	
	Entrada enter (EntradaClock, Botao, Sw, resultadoEntrada, saidaBotao, Clock, EnableClock);
	
	UnidadeControle UC (Instrucao[31:26], Clock, saidaBotao, ALUOp, RegDst, MemRead, MemtoReg, MemWrite, 
		ALUSrc, RegWrite, PCFunct, BEQ, BNE, ControlJump, Halt, In, Out, EnableClock, JAL, EnableDisp, savePC, 
		savePCBuffer, setClock, getInterruption);
	
	UnidadeControleULA UCA (Instrucao[5:0], ALUOp, Control_ALU, JALR, JR);
	
	BancodeRegistradores BR (.Clock(Clock), .Reg1(Instrucao[25:21]), .Reg2(Instrucao[20:16]), .RegEscrita(EscolhidoMultiplexadorDestino), 
		.RegWrite(RegWrite), .Dado1(BR_Dado1), .Dado2(BR_Dado2), .EscreveDado(Escolhido_MultiplexadorPC), .DadoNoRegDeEscrita(ResultadoEscritaBanco), .FP(FP));
	
	ULA alu (BR_Dado1, Escolhido_MultiplexadorALUSrc, Control_ALU, Saida_ULA, Zero, Instrucao[10:6]);
	
	MemoriaDados MD (BR_Dado2, Saida_ULA, Saida_ULA, MemWrite, ~Clock, Clock, DadoMemoriaRAM);
	
	MultiplexadorMemtoReg MMTR(DadoMemoriaRAM, Saida_ULA, MemtoReg, Escolhido_MultiplexadorMemtoReg);
	
	MultiplexadorALUSrc MAS (Imediato_extendido, BR_Dado2, ALUSrc, Escolhido_MultiplexadorALUSrc);
	
	MultiplexadorRegDst MRD (Instrucao[20:16], Instrucao[15:11], RegDst, EscolhidoMultiplexadorRegDst);
	
	PCVersion2 PC (Clock, PCFunct, novoValorPC, EnderecoInstrucao);
	
	ROM ReadOnly(EnderecoInstrucao, Clock, Instrucao);
	
	Branch Bran (Imediato_extendido, EnderecoInstrucao, ControlBranch, JumpContext, NovoEndereco, extra);

	Jump Salto (Instrucao[25:0], JumpContext, Imediato_extendido, EnderecoDoJump);
	
	MultiplexadorJump MJ (NovoEndereco, EnderecoDoJump, ControlJump, Escolhido_MultiplexadorJump);
	
	BNEandBEQ BAQ (BEQ, BNE, Zero, ControlBranch);
	
	MultiplexadorEntrada ME (resultadoEntrada, Escolhido_MultiplexadorJAL, In, EscolhidoMultiplexadorEntrada);
	
	MultiplexadorSaida MS (resultadoEntrada, Saida_ULA, In, Out, EsolhidoMultiplexadorSaida);
	
	MultiplexadorDestino MDJAL (EscolhidoMultiplexadorRegDst, JAL, JALR, EscolhidoMultiplexadorDestino);
	
	MultiplexadorJAL MJAL (NovoEndereco, Escolhido_MultiplexadorMemtoReg, JALR, JAL, Escolhido_MultiplexadorJAL);
	
	MultiplexadorJumpReg jreg (BR_Dado1, Escolhido_MultiplexadorJump, JALR, JR, Escolhido_MultiplexadorJumpReg);
	
	MultiplexadorPC pc(.valorPC(EnderecoInstrucao), .valorPCBuffer(bufferPC), .dado(EscolhidoMultiplexadorEntrada), 
		.savePC(savePC), .savePCBuffer(savePCBuffer), .Escolhido_MultiplexadorPC(Escolhido_MultiplexadorPC), .getInterruption(getInterruption), .qualInterrupcao(qualInterrupcao));
	
	tela_LCD lcd (.clock_50(EntradaClock), .Switches(resultadoEntrada), .LCD_ON(LCD_ON), .LCD_BLON(LCD_BLON), .LCD_RW(LCD_RW), 
		.LCD_EN(LCD_EN), .LCD_RS(LCD_RS), .LCD_DATA(LCD_DATA), .Immediate(Instrucao[15:0]), .clock(Clock), .EnableDisplay(EnableDisp),
		.Data1(BR_Dado1), .Data2(BR_Dado2));

	interruption inter (.halt(Halt), .clk(Clock), .set(setClock), .pc(EnderecoInstrucao), .int_halt(int_halt), .int_clk(int_clk), .int_time(Instrucao[15:0]));

endmodule 
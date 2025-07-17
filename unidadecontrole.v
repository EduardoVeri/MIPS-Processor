module UnidadeControle (
    input [5:0] Opcode,
    input clock,
    Button,
    output [2:0] AluOp,
    output [1:0] In,
    output RegDst,
    MemRead,
    MemtoReg,
    MemWrite,
    ALUSrc,
    RegWrite,
    PCFunct,
    BEQ,
    BNE,
    ControlJump,
    Halt,
    Out,
    EnableClock,
    JAL,
    Disp,
    savePC,
    savePCBuffer,
    setClock,
    getInterruption,
    output reg FrameBufferWrite
);

  reg
      REGRegDst,
      REGMemRead,
      REGMemtoReg,
      REGMemWrite,
      REGALUSrc,
      REGRegWrite,
      REGPCFunct,
      REGBEQ,
      REGBNE,
      REGControlJump,
      RegHalt,
      RegOut,
      REGJAL,
      REGDisp,
      REGsavePC,
      REGsavePCBuffer,
      REGsetClock,
      REGgetInterruption;
  reg [1:0] RegIn;
  reg [2:0] REGAluOp;
  reg RegEnable;

  always @(*) begin
    FrameBufferWrite <= 0; // Default value for framebuffer write


    case (Opcode)  // Tipo R
      6'b000000: begin
        REGRegWrite <= 1;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 0;
        REGRegDst <= 0;
        REGPCFunct <= 1;
        REGAluOp <= 3'b010;  // Verificaçao FUNCT
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end
      6'b100011: begin  // LW
        REGRegWrite <= 1;
        REGMemRead <= 1;
        REGMemWrite <= 0;
        REGMemtoReg <= 1;
        REGALUSrc <= 1;
        REGRegDst <= 1;
        REGPCFunct <= 1;
        REGAluOp <= 3'b000;  // SOMA
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end
      6'b101011: begin  // SW
        REGRegWrite <= 0;
        REGMemRead <= 0;
        REGMemWrite <= 1;
        REGMemtoReg <= 1;  // Don't Care
        REGALUSrc <= 1;
        REGRegDst <= 1;
        REGPCFunct <= 1;
        REGAluOp <= 3'b000;  // SOMA
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end
      6'b001000: begin  // ADDI
        REGRegWrite <= 1;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 1;
        REGRegDst <= 1;
        REGPCFunct <= 1;
        REGAluOp <= 3'b000;  // SOMA
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end
      6'b001001: begin  // SUBI
        REGRegWrite <= 1;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 1;
        REGRegDst <= 1;
        REGPCFunct <= 1;
        REGAluOp <= 3'b001;  // SUB
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end
      6'b001100: begin  // ANDI
        REGRegWrite <= 1;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 1;
        REGRegDst <= 1;
        REGPCFunct <= 1;
        REGAluOp <= 3'b011;  // AND
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end
      6'b001101: begin  // ORI
        REGRegWrite <= 1;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 1;
        REGRegDst <= 1;
        REGPCFunct <= 1;
        REGAluOp <= 3'b100;  // OR
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end
      6'b000100: begin  // REGBEQ
        REGRegWrite <= 0;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 0;
        REGRegDst <= 0;
        REGPCFunct <= 1;
        REGAluOp <= 3'b001;  // SUB
        REGBEQ <= 1;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end
      6'b000101: begin  // REGBNE
        REGRegWrite <= 0;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 0;
        REGRegDst <= 0;
        REGPCFunct <= 1;
        REGAluOp <= 3'b001;  // SUB
        REGBEQ <= 0;
        REGBNE <= 1;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end
      6'b001010: begin  // SLTI
        REGRegWrite <= 1;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 1;
        REGRegDst <= 1;
        REGPCFunct <= 1;
        REGAluOp <= 3'b101;  // SLT
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end

      6'b011111: begin  // IN
        REGRegWrite <= 1;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 0;
        REGRegDst <= 1;
        REGPCFunct <= 1;
        REGAluOp <= 3'b000;  // SOMA
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 1;
        RegOut <= 0;
        RegEnable <= 0;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end

      6'b011110: begin  // Out
        REGRegWrite <= 0;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 0;
        REGRegDst <= 0;
        REGPCFunct <= 1;
        REGAluOp <= 3'b000;  // SOMA
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 1;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end

      6'b000010: begin  // Jump
        REGRegWrite <= 0;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 0;
        REGRegDst <= 0;
        REGPCFunct <= 1;
        REGAluOp <= 3'b000;  // SOMA
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 1;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end

      6'b000011: begin  // JAL
        REGRegWrite <= 1;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 0;
        REGRegDst <= 0;
        REGPCFunct <= 1;
        REGAluOp <= 3'b000;  // SOMA	
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 1;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 1;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end

      6'b111111: begin  //Halt
        REGRegWrite <= 0;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 0;
        REGRegDst <= 0;
        REGPCFunct <= 0;
        REGAluOp <= 3'b000;  // SOMA	
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 1;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end

      6'b101101: begin  // XORI
        REGRegWrite <= 1;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 1;
        REGRegDst <= 1;
        REGPCFunct <= 1;
        REGAluOp <= 3'b110;  // XOR
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end

      6'b111110: begin  // DISP
        REGRegWrite <= 0;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 0;
        REGRegDst <= 0;
        REGPCFunct <= 1;
        REGAluOp <= 3'b000;  // ADD
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 1;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end

      6'b100100: begin  // PC
        REGRegWrite <= 1;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 0;
        REGRegDst <= 1;
        REGPCFunct <= 1;
        REGAluOp <= 3'b000;  // ADD
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 1;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end

      6'b110100: begin  // Save the PC value at the buffer
        REGRegWrite <= 1;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 0;
        REGRegDst <= 1;
        REGPCFunct <= 1;
        REGAluOp <= 3'b000;  // ADD
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 1;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end

      6'b000001: begin  // Set clock
        REGRegWrite <= 0;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 0;
        REGRegDst <= 0;
        REGPCFunct <= 1;
        REGAluOp <= 3'b000;  // ADD
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 1;
        REGgetInterruption <= 0;
      end

      6'b000110: begin  // Get Interruption
        REGRegWrite <= 1;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 0;
        REGRegDst <= 1;
        REGPCFunct <= 1;
        REGAluOp <= 3'b000;  // ADD
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 1;
      end

      6'b000111: begin  // Get Keyboard 
        REGRegWrite <= 1;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 0;
        REGALUSrc <= 0;
        REGRegDst <= 1;
        REGPCFunct <= 1;
        REGAluOp <= 3'b000;  // SOMA
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 2;  // Keyboard Input
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
      end

      6'b001111: begin // Pixel drawing
        REGRegWrite <= 0;
        REGMemRead <= 0;
        REGMemWrite <= 0;
        REGMemtoReg <= 1;  // Don't Care
        REGALUSrc <= 1;
        REGRegDst <= 1;
        REGPCFunct <= 1;
        REGAluOp <= 3'b000;  // SOMA
        REGBEQ <= 0;
        REGBNE <= 0;
        REGControlJump <= 0;
        RegHalt <= 0;
        RegIn <= 0;
        RegOut <= 0;
        RegEnable <= 1;
        REGJAL <= 0;
        REGDisp <= 0;
        REGsavePC <= 0;
        REGsavePCBuffer <= 0;
        REGsetClock <= 0;
        REGgetInterruption <= 0;
        FrameBufferWrite <= 1; // Enable framebuffer write
      end

    endcase
  end


  assign JAL = REGJAL;
  assign EnableClock = RegEnable;
  assign Halt = RegHalt;
  assign RegDst = REGRegDst;
  assign MemRead = REGMemRead;
  assign MemtoReg = REGMemtoReg;
  assign MemWrite = REGMemWrite;
  assign ALUSrc = REGALUSrc;
  assign RegWrite = REGRegWrite;
  assign PCFunct = REGPCFunct;
  assign AluOp = REGAluOp;
  assign BEQ = REGBEQ;
  assign BNE = REGBNE;
  assign ControlJump = REGControlJump;
  assign In = RegIn;
  assign Out = RegOut;
  assign Disp = REGDisp;
  assign savePC = REGsavePC;
  assign savePCBuffer = REGsavePCBuffer;
  assign setClock = REGsetClock;
  assign getInterruption = REGgetInterruption;

endmodule

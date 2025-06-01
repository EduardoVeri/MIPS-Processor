module Entrada (
    input Clock,
    Botao,
    input [13:0] Sw,
    input wire ps2_clk,
    input wire ps2_data,
    input Pause,
    input [1:0] In,
    output [13:0] resultadoEntrada,
    output reg [7:0] resultadoKeyBoard,
    output saidaBotao,
    saidaClock
);

  wire [7:0] ps2_keyboard_data;
  reg [7:0] KeyBoardBuffer;
  reg [25:0] out;
  reg [12:0] resultado;
  reg RegClock;
  reg [5:0] Debouncer;
  reg data_valid;
  integer contadorDebouncer = 1;
  integer contador = 0;

  initial begin
    KeyBoardBuffer = 8'd0;
    resultadoKeyBoard = 8'd0;
    out = 26'd0;
    resultado = 14'd0;
    RegClock = 1'b0;
    Debouncer = 6'd0;
  end

  PS2Key i_ps2Key (
      .clk(Clock),
      .PS2_clk(ps2_clk),
      .PS2_DAT(ps2_data),
      .data(ps2_keyboard_data),
      .data_valid(data_valid)
  );

  always @(posedge Clock) begin
    if ((Botao == 0) && (Debouncer[5] != 1)) Debouncer = Debouncer + 1;
    else if (Botao == 1) Debouncer = 6'd0;
  end

  always @(posedge Clock) begin
    if (contador == 0) begin
      RegClock = 0;
      contador = 1;
    end

    // O valor de S apenas será alterado quando o valor de out atingir o valor de 50000000
    if (Pause == 1 || Pause == 0) begin
      if (out == 26'd1562500) begin
        out      = 26'd0;
        RegClock = ~RegClock;
      end else out = out + 1;
    end else begin
      if (Debouncer[5] == 1) begin
        if (out == 26'd25000000) begin
          out      = 26'd0;
          RegClock = ~RegClock;
        end else out = out + 1;
      end
    end
  end

  always @(*) begin
    if (Sw[13] == 1) resultado = {1'd0, Sw[12:0]};
  end

  always @(posedge Clock) begin
    if (data_valid == 1'b1) begin
      KeyBoardBuffer <= ps2_keyboard_data;
    end

    if (In == 2'b10) begin
      resultadoKeyBoard <= KeyBoardBuffer;
      KeyBoardBuffer <= 8'd0;
    end else begin
      resultadoKeyBoard <= 8'd0;
    end
  end

  assign saidaBotao = Debouncer[5];
  assign saidaClock = RegClock;
  assign resultadoEntrada = resultado;

endmodule

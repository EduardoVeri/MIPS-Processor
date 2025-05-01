module Saida (input [31:0] ValorSaida,
              input halt,
              ClockCPU,
              EnableOut,
              EnableIn,
              output [13:0] Led,
              output [6:0] Display1,
              Display2,
              Display3,
              Display4,
              DisplayRef,
              Display6,
              Display_FP1,
              Display_FP2,
              input [9:0] PC,
              input [31:0] FP,
              output [7:0] seg,
              output [3:0] dig,        // Digit pins (active-low)
              input clk);
    
    reg[31:0] valorDisplay1, valorDisplay2, valorDisplay3, valorDisplay4, valorDisplayRef, valorDisplay6, valorDisplayFP1, valorDisplayFP2;
    reg regLed13; // Trocar por um verde
    reg [12:0] RegLeds;
    wire [6:0] _seg;
    reg [3:0] _dig;
    
    integer contador1 = 1;
    integer contador2 = 1;
    
    initial begin
        valorDisplay1 = 4'd1;
        valorDisplay2 = 4'd2;
        valorDisplay3 = 4'd3;
        valorDisplay4 = 4'd4;
    end
    
    
    reg [1:0] digit_sel = 0;     // Current digit (0-3)
    reg [3:0] digit_values [3:0];
    
    reg [19:0] clk_240hz = 0;
    always @(posedge clk) begin
        clk_240hz < = (clk_240hz == 20'd208333) ? 0 : clk_240hz + 1;
    end
    
    always @(posedge clk) begin
        if (clk_240hz == 20'd208333) begin
            digit_sel <= digit_sel + 1;
        end
    end
    
    always @(negedge ClockCPU) begin
        
        if (ClockCPU) begin
            ;
        end
        
        valorDisplayFP1 = FP%10;
        valorDisplayFP2 = (FP%100)/10;
        
        
        if (contador1 == 1) begin
            valorDisplay1 = 4'd1;
            valorDisplay2 = 4'd2;
            valorDisplay3 = 4'd3;
            valorDisplay4 = 4'd4;
            contador1     = 0;
        end
        else begin
            if (EnableOut) begin
                valorDisplay1 = ValorSaida%10;
                valorDisplay2 = (ValorSaida%100)/10;
                valorDisplay3 = (ValorSaida%1000)/100;
                valorDisplay4 = (ValorSaida%10000)/1000;
                
                digit_values[0] = valorDisplay1[3:0];
                digit_values[1] = valorDisplay2[3:0];
                digit_values[2] = valorDisplay3[3:0];
                digit_values[3] = valorDisplay4[3:0];
            end
        end
    end
    
    
    always @(posedge clk_240hz)
    begin
        if (halt == 1) begin
            valorDisplayRef = 4'b1111;
            valorDisplay6   = 4'b1111;
            regLed13        = 1;
        end
        else begin
            valorDisplay6   = PC%10;
            valorDisplayRef = (PC%100)/10;
            regLed13        = 0;
        end
        
        if (contador2) begin
            RegLeds   = 13'd0;
            contador2 = 0;
        end
            if (EnableIn)
                RegLeds = ValorSaida;
                end
        
        
        
        
        
        always @(posedge clk) begin
            case (digit_sel)
                2'd0: _dig    = 4'b1110; // Enable digit 0
                2'd1: _dig    = 4'b1101; // Enable digit 1
                2'd2: _dig    = 4'b1011; // Enable digit 2
                2'd3: _dig    = 4'b0111; // Enable digit 3
                default: _dig = 4'b1111;
            endcase
        end
        
        
        
        Contato1 bcd1 (valorDisplay1, Display1);
        Contato1 bcd2 (valorDisplay2, Display2);
        Contato1 bcd3 (valorDisplay3, Display3);
        Contato1 bcd4 (valorDisplay4, Display4);
        Contato1 bcd5 (valorDisplayRef, DisplayRef);
        Contato1 bcd6 (valorDisplay6, Display6);
        Contato1 bcd7 (valorDisplayFP1, Display_FP1);
        Contato1 bcd8 (valorDisplayFP2, Display_FP2);
        Contato1 bcd9 (digit_values[digit_sel], _seg);
        
        assign seg = {1'd1, _seg[6:0]};
        assign dig = _dig;
        
        assign Led = {regLed13, RegLeds[12:0]};
        
        endmodule

// Um módulo para gerar interrupções no processador

module interruption (
    input halt, // Sinal de parada do processo
    input clk, // Clock
    input set, // Sinal para setar o tempo de interrupção
    input [9:0] pc,
    input [15:0] int_time,
    output reg int_halt, // Sinal de interrupção
    output reg int_clk, // Sinal de interrupção
    output reg [9:0] save_pc
);

    reg [8:0] timer; // Timer para interrupção
    reg [15:0] reg_int_time; // Registrador para o tempo de interrupção
    reg start; // Registrador para o sinal de start
    integer contador = 1;
    
    /* Quando o comando start for ativado o sinal de interrupção irá começar 
    a contar um timer que dara a interrupção após ## ciclos de clock */
    always @(negedge clk) begin
        if (contador) begin
            contador = 0;
            start = 0;
            timer = 9'd0;
        end
        
        if (set) begin
            timer = 9'd0;
            start = 1;
            reg_int_time = int_time;
        end

        if (start) begin
            timer = timer + 1;
            if (timer >= reg_int_time) begin
                int_clk = 1;
                save_pc = pc;
                timer = 9'd0;
                start = 0;
            end
        end
        else begin
            int_clk = 0;
            timer = 9'd0;
        end

        if (halt) begin
            int_halt = 1;
            start = 0;
            save_pc = pc;
        end
        else begin
            int_halt = 0;
        end
    end

endmodule



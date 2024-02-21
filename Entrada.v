module Entrada (
	input Clock, Botao,
	input [13:0] Sw, 
	output [13:0] resultadoEntrada,
	output saidaBotao, saidaClock,
	input Pause
);
	reg[25:0] out;
	reg [12:0] resultado;
	reg RegClock;
	reg [5:0] Debouncer;
	integer contadorDebouncer = 1;
	integer contador = 0;

	always @(posedge Clock) begin
		
		if ((Botao == 0) && (Debouncer[5] != 1))
			Debouncer = Debouncer + 1;
		else if (Botao == 1)
			Debouncer = 6'd0;
		
	end
	
	always@(posedge Clock) begin
		if (contador == 0) begin
			RegClock = 0;
			contador = 1;
		end
		
		// O valor de S apenas será alterado quando o valor de out atingir o valor de 50000000
		if (Pause == 1) begin
			if(out == 26'd6250000) begin
				out = 26'd0;
				RegClock = ~RegClock;
			end
			else
				out = out + 1;
		end
		else begin
			if(Debouncer[5] == 1) begin
				if(out == 26'd25000000) begin
					out = 26'd0;
					RegClock = ~RegClock;
				end
				else
					out = out + 1;	
			end
		end
	end

	always @(*) begin
		if (Sw[13] == 1)
			resultado = {1'd0, Sw[12:0]};
	end
	
	assign saidaBotao = Debouncer[5];
	assign saidaClock = RegClock;
	assign resultadoEntrada = resultado;
	
endmodule 
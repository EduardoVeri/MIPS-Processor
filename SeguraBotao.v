/*module SeguraBotao(
	input Botao,
	output RegSaida
);
	reg RegLibera;
	
	initial begin
		RegLibera = 0;
	end
	
	always @(posedge Sw) begin
		RegLibera = 1;
	end
		
	always @(posedge Clock) begin
		if(out == 26'd50000000) begin
			out = 26'd0;
			RegLibera = 0;
		end
		else
			out = out + 1;
	end
	
	assign RegSaida = RegBotao;

endmodule
*/
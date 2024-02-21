

//Modulo do Banco de Registradores
module BancodeRegistradores(Clock, Reg1, Reg2, RegEscrita, RegWrite, 
	Dado1, Dado2, EscreveDado, DadoNoRegDeEscrita, FP);

	input wire Clock, RegWrite;
	input wire [4:0] Reg1, Reg2; 
	input wire [5:0] RegEscrita;
	input wire [31:0] EscreveDado;
	output wire [31:0] Dado1, Dado2, DadoNoRegDeEscrita, FP;
	
	reg [31:0] Registradores [31:0];
	
	integer primeiro = 1;
	
	// Verificar qual borda será utilizada nesse módulo
	always @(posedge Clock) begin
		
		if(primeiro == 1) begin
			Registradores[31] <= 32'd0; // Registrador $zero 
			Registradores[1] <= 32'd102;
			Registradores[2] <= 32'd54;
			Registradores[3] <= 32'd4;
			Registradores[4] <= 32'd10;
			primeiro <= 2;
		end
		

		if ((RegWrite == 1) && (RegEscrita != 5'd31)) begin
		
			Registradores[RegEscrita] <= EscreveDado;
			
		end
		
	end
	/*
	always @(negedge Clock) begin
	
		if (int_clk || int_halt) begin
		
			Registradores[32] <= int_pc;
			
		end
	
	end*/

	assign DadoNoRegDeEscrita = Registradores[RegEscrita];	
	assign Dado1 = Registradores[Reg1];
	assign Dado2 = Registradores[Reg2];	
	assign FP = Registradores[5'd29];
	
endmodule 



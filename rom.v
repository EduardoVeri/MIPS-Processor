
// Modulo para a Memória de Instrução

// Valor do parâmetro ADDR_WIDTH será ajustado confome necessário
module ROM
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=11)
(
	input [(ADDR_WIDTH-1):0] addr,
	input clk, 
	output reg [(DATA_WIDTH-1):0] q
);

	// Declaração do vetor de registrador que será a memória
	reg [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0];
	
	/*
		Por ser uma memória do tipo read only, é necessário 
		específicar o arquivo em que estará armazenada as 
		instruções.
	*/
	initial
	begin
		$readmemb("single_port_rom_init.txt", rom);
	end
	
	
	always @ (*)
	begin
		q <= rom[addr];
	end

endmodule


module MultiplexadorPC(
	input [10:0] valorPC, valorPCBuffer, 
	input [31:0] dado, qualInterrupcao,
	input savePC, savePCBuffer, getInterruption,
	input getPC,
	output [31:0] Escolhido_MultiplexadorPC
);
	
	reg [31:0] escolhido;
	
	always @(*) begin
	
		if(savePC == 1) begin
			escolhido = {21'd0, valorPC};
		end
		else if(savePCBuffer == 1) begin
			escolhido = {21'd0, valorPCBuffer};
		end
		else if(getInterruption == 1) begin
			escolhido = qualInterrupcao;
		end	
		else begin
			escolhido = dado;
		end
		
	end
	
	assign Escolhido_MultiplexadorPC = escolhido;
	
endmodule



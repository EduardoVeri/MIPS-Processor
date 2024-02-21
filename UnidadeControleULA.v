
module UnidadeControleULA (
	input [5:0] Funct,
	input [2:0] AluOp,
	output [3:0] ControleALU,
	output JALR, JR
);
	
	reg[3:0] RegControle;
	reg RegJALR, RegJR;
	
	always @(*) 
	begin

		case(AluOp)
			3'b000: begin 
				RegControle = 4'b0010; //SOMA
				RegJALR = 0;
				RegJR = 0;
			end
			3'b001: begin
				RegControle = 4'b0110; //SUB
				RegJALR = 0;
				RegJR = 0;
			end
			3'b010: //FUNCT
			begin 
				case(Funct)
					6'b100000: begin 
						RegControle = 4'b0010; //SOMA
						RegJALR = 0;
						RegJR = 0;
					end
					6'b100010: begin 
						RegControle = 4'b0110; //SUB
						RegJALR = 0;
						RegJR = 0;
					end
					6'b100100: begin
						RegControle = 4'b0000; //AND
						RegJALR = 0;
						RegJR = 0;
					end
					6'b101101: begin 
						RegControle = 4'b0011; //XOR
						RegJALR = 0;
						RegJR = 0;
					end
					6'b100101: begin
						RegControle = 4'b0001; //OR
						RegJALR = 0;
						RegJR = 0;
					end
					6'b001000: begin //JR
						RegControle = 4'b0010; //SOMA
						RegJALR = 0;
						RegJR = 1;
					end
					6'b001001: begin //JALR
						RegControle = 4'b0000; //SOMA
						RegJR = 0;
						RegJALR = 1;
					end
					6'b101010: begin
						RegControle = 4'b0111; //SLT
						RegJALR = 0;
						RegJR = 0;
					end
					6'b100111: begin
						RegControle = 4'b1100; //NOR
						RegJALR = 0;
						RegJR = 0;
					end
					6'b000000: begin
						RegControle = 4'b1111; //SLL
						RegJALR = 0;
						RegJR = 0;
					end
					6'b000010: begin
						RegControle = 4'b1101; //SRL
						RegJALR = 0;
						RegJR = 0;
					end
					6'b011010: begin
						RegControle = 4'b1001; //DIV
						RegJALR = 0;
						RegJR = 0;
					end
					6'b011000: begin
						RegControle = 4'b1000; //MULT
						RegJALR = 0;
						RegJR = 0;
					end
				endcase
			end
			3'b011: begin
				RegControle = 4'b0000; //AND
				RegJALR = 0;
				RegJR = 0;
			end
			3'b100: begin
				RegControle = 4'b0001; //OR
				RegJALR = 0;
				RegJR = 0;
			end
			3'b101: begin
				RegControle = 4'b0111; //SLT
				RegJALR = 0;
				RegJR = 0;
			end
			3'b110: begin
				RegControle = 4'b0011;
				RegJALR = 0;
				RegJR = 0;
			end
		endcase
		
	end
	
	assign ControleALU = RegControle;
	assign JALR = RegJALR;
	assign JR = RegJR;


endmodule 


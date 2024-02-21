
//	Modulo da Unidade Lógica e Aritmética.
module ULA (Input_1, Input_2, Control_ALU, Output_Resultado, Zero, Shamt);
	
	input wire[31:0] Input_1;
	input wire[31:0] Input_2;
	input wire [4:0] Shamt;
	input wire[3:0] Control_ALU;
	output wire[31:0] Output_Resultado;
	output wire Zero;
	reg[31:0] resultado, resultadoParcial;
   reg reg_Zero;
   
	// Inicia o resultado para que seja sempre 0 no primeiro clock
	initial begin
		 resultado <= 32'd0;
	end
	
	/*
		O caculo em um circuito combinacional é realizado sempre que existe uma mudança
		de valores de entrada.
	*/
	always @(*) begin
		
		// Seleção de funcionalidades da ULA
		case(Control_ALU)
			4'b0000: resultado = Input_1 & Input_2;//AND
			4'b0001: resultado = Input_1 | Input_2;//OR
			4'b0010: resultado = Input_1 + Input_2;//Soma
			4'b0110: resultado = Input_1 - Input_2;//Subtração
			4'b0011: resultado = Input_1 ^ Input_2;//XOR
			4'b0111: begin 
			
						  if(Input_1 < Input_2) begin //Set on Less Than
								resultado = 32'd1;
						  end			  
						  else begin
								resultado = 32'd0;
						  end
			        end
			4'b1000: resultado = Input_1 * Input_2;
			4'b1001: resultado = Input_1 / Input_2;
			4'b1100: resultado = ~(Input_1 | Input_2);//NOR
			4'b1101: resultado = Input_1 >> Shamt;//Shift a esquerda
			4'b1111: resultado = Input_1 << Shamt;//Shif a direita
				
		endcase
		
		/* 
			Verifica se o resultado obtido no calculo anterior foi igual
			a zero. Em caso afirmativo, a flag regZero fica em alta.
		*/
		
	   if(Output_Resultado == 32'd0) begin
			reg_Zero = 1'b1;
		end
		
		else begin	
			reg_Zero = 1'b0;
		end
	
	end

	// Atribui os valores aos cabos de saída
	assign Output_Resultado = resultado;
	assign Zero = reg_Zero;

endmodule

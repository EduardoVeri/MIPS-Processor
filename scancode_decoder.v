module scancode_decoder (
    input  wire       clk,
    input  wire [7:0] scan_code,
    output reg  [7:0] ascii_code
);

  // PS/2 Set 2 Make Codes (Single Byte)

  // Numbers 0-9
  localparam KEY_0 = 8'h45;
  localparam KEY_1 = 8'h16;
  localparam KEY_2 = 8'h1E;
  localparam KEY_3 = 8'h26;
  localparam KEY_4 = 8'h25;
  localparam KEY_5 = 8'h2E;
  localparam KEY_6 = 8'h36;
  localparam KEY_7 = 8'h3D;
  localparam KEY_8 = 8'h3E;
  localparam KEY_9 = 8'h46;

  // Letters A - F (Hexadecimal)
  localparam KEY_A = 8'h1C;
  localparam KEY_B = 8'h32;
  localparam KEY_C = 8'h21;
  localparam KEY_D = 8'h23;
  localparam KEY_E = 8'h24;
  localparam KEY_F = 8'h2B;

  // A Keyboard Enter Key (Can be any key, but this is a common one)
  localparam KEY_ENTER = 8'h5A;

  always @(posedge clk) begin
    case (scan_code)
      KEY_0: begin
        ascii_code <= 8'h30;
      end  // ASCII '0'
      KEY_1: begin
        ascii_code <= 8'h31;
      end  // ASCII '1'
      KEY_2: begin
        ascii_code <= 8'h32;
      end  // ASCII '2'
      KEY_3: begin
        ascii_code <= 8'h33;
      end  // ASCII '3'
      KEY_4: begin
        ascii_code <= 8'h34;
      end  // ASCII '4'
      KEY_5: begin
        ascii_code <= 8'h35;
      end  // ASCII '5'
      KEY_6: begin
        ascii_code <= 8'h36;
      end  // ASCII '6'
      KEY_7: begin
        ascii_code <= 8'h37;
      end  // ASCII '7'
      KEY_8: begin
        ascii_code <= 8'h38;
      end  // ASCII '8'
      KEY_9: begin
        ascii_code <= 8'h39;
      end  // ASCII '9'
      KEY_ENTER: begin
        ascii_code <= 8'h0D;
      end  // ASCII CR (Carriage Return)
      default: begin
        ascii_code <= scan_code;  // For debugging: output raw scan code
      end
    endcase
  end

endmodule

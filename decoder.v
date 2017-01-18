  output reg [0：6] HEX0;
  input [0:3] SW;


  always @ *
    case (SW)
      0: HEX0 = 7'b0000001;
      1: HEX0 = 7'b1001111;
      2: HEX0 = 7'b0010010;
      3: HEX0 = 7'b0000110;
      4: HEX0 = 7'b1001100;
      5: HEX0 = 7'b0100100;
      6: HEX0 = 7'b0000001;
      7: HEX0 = 7'b0001111;
      8: HEX0 = 7'b0000000;
      9: HEX0 = 7'b0000100;
      10: HEX0 = 7'b0001000;
      11: HEX0 = 7'b1100000;
      12: HEX0 = 7'b0110001;
      13: HEX0 = 7'b1000010;
      14: HEX0 = 7'b0110000;
      15: HEX0 = 7'b0111000;
    endcase
endmodule
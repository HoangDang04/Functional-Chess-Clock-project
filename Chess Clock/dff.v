module dff(clkclk, d, q, qbar, rst);
//rising clock-edge dff with active high synchronous reset
  input clkclk, rst, d;
  output reg q;
  output qbar;
  assign qbar = ~q;
  always @(posedge clkclk)
    if (rst == 1'b1) q <= 1'b0;
    else q <= d;
endmodule
  module Clock_Normal (
    input clk, //clock of arty z7
    input sw, //switch[0] to enable the clock
    input on,
    input btnC, //reset the clock
    input btnU, //min increment
    input btnR, //sec increment
    input btnUd, //hour decrement
    input btnRd, //min decrement
    output [6:0] seg,
    output [3:0] select
);
    wire [3:0] s1, s2, m1, m2, h1, h2;
    reg secup, minup, secdown, mindown;
    wire btnCclr, btnUclr, btnRclr, btnUdclr, btnRdclr;
    reg btnCclr_prev, btnUclr_prev, btnRclr_prev, btnUdclr_prev, btnRdclr_prev;

    // debounce the button
    debounce dbC(clk, btnC, btnCclr); //clear
    debounce dbU(clk, btnU, btnUclr); //min up
    debounce dbR(clk, btnR, btnRclr); //second up
    debounce dbUd(clk, btnUd, btnUdclr); //min up
    debounce dbRd(clk, btnRd, btnRdclr); //seccond up
    
    //instantiate seven segments driver
    express_4nums express(clk, 1'b0, m2, m1, s2, s1, seg, select);
    digital_clock dig_clk(clk, sw, btnCclr, on, minup, secup, mindown, secdown, s1, s2, m1, m2, h1, h2);

    always @(posedge clk)
    begin
        btnUclr_prev <= btnUclr;
        btnRclr_prev <= btnRclr;
        btnUdclr_prev <= btnUdclr;
        btnRdclr_prev <= btnRdclr;
    end
    always @(btnUclr, btnRclr, btnUdclr, btnRdclr)
    begin
         if (btnUdclr_prev == 1'b0 && btnUdclr == 1'b1) mindown = 1'b1; else mindown = 1'b0;
         if (btnRdclr_prev == 1'b0 && btnRdclr == 1'b1) secdown = 1'b1; else secdown = 1'b0;
         if (btnUclr_prev == 1'b0 && btnUclr == 1'b1) minup = 1'b1; else minup = 1'b0;
         if (btnRclr_prev == 1'b0 && btnRclr == 1'b1) secup = 1'b1; else secup = 1'b0;
    end
endmodule                
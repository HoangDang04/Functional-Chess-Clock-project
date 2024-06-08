module debounce (
    input clk,
    input but,
    output led
);
    wire clkclk;
    clock slowclk(clk, clkclk);

    wire q1, q2o;
    dff name1(clkclk, but, q1, , );
    dff name2(clkclk, q1, , q2o, );

    assign led = q1 & q2o;
endmodule
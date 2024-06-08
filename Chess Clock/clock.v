module clock(
    input clk, //clock of arty z7
    output reg led
);
    integer count = 0;
    always @(posedge clk)
    begin
        count <= count + 1;
        if (count == 1000000) led <=1;
        else if (count == 2000000)
        begin
            led <= 0;
            count <=0;
        end
    end
endmodule
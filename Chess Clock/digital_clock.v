module digital_clock (
    input clk, // clock of arty z7
    input en, // assign it to a switch
    input rst,
    input on,
    input minup, 
    input secup,
    input mindown,
    input secdown,
    output [3:0] s1,
    output [3:0] s2,
    output [3:0] m1,    // all these are what we show on the 7 segment (0-9 : 4 bits)
    output [3:0] m2,
    output [3:0] h1,
    output [3:0] h2
);
    // h2 h1 : m2 m1
    reg [5:0] hour = 0, min = 0, sec = 0; // 60 : 6 bits
    integer clkc = 0;
    always @(posedge clk)
    begin
        if (on == 1'b1)
        begin
            //reset clock
            if (rst==1'b1) {hour, min, sec} <= 0;
            //set clock
            else if (minup == 1)
                if (min == 59) min <= 0;
                else min <= min + 1;
            else if (secup == 1)
                if (sec == 59) sec <= 0;
                else sec <= sec + 1;
            else if (secdown == 1)
                if (sec == 0) sec <=59;
                else sec <= sec - 1;
            else if (mindown == 1)
                if (min == 0) min <=59;
                else min <= min - 1;
        end
        // count
        if (en == 1)
            if (clkc == 125000000)
            begin
                clkc <= 0;
                if (sec == 0)
                begin
                    if (min == 0)
                    begin
                        if (hour == 0)
                        begin
                            {hour, min, sec} <= 0;    
                        end
                        else
                        begin
                            hour <= hour - 1;
                            min <= 59;
                            sec <= 59;
                        end
                    end
                    else
                    begin
                        min <= min - 1;
                        sec <= 59;
                    end
                end
                else
                    sec <= sec - 1;
            end
            else clkc <= clkc + 1;
    end
    BintoBCD secs(.binary(sec), .thou(), .hund(), .tens(s2), .ones(s1));
    BintoBCD mins(.binary(min), .thou(), .hund(), .tens(m2), .ones(m1));
    BintoBCD hours(.binary(hour), .thou(), .hund(), .tens(h2), .ones(h1));
endmodule
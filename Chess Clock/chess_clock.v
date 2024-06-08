module chess_clock (
    input clk, // clock of arty z7
    input btn2, // enable clock 1, unable clock 2
    input btn1, // enable clock 2, unable clock 1
    input stopp,
    input change, // select another clock to set up
    input btnC, //reset the clock
    input btnU, //min increment
    input btnR, //sec increment
    input btnUd, //min decrement
    input btnRd, //sec decrement
    output [6:0] seg, segO,
    output [3:0] select, selectO,
    output reg in_select1, in_select2
);

    // reg [7:0] led, ledO;
    reg en1 = 0, en2 = 0, on1 = 1, on2 = 0, sel = 0, change_clr_pre;
    wire change_clr;

    debounce chg(clk, change, change_clr);
    always @(posedge clk) 
    begin
        change_clr_pre <= change_clr;
        if (change_clr_pre == 0 && change_clr == 1) sel <=~sel;
    end
    always @(posedge clk)
    begin
        if (sel == 0)
        begin
            on1 <= 0; 
            on2 <= 1; 
            if (stopp == 0)
            begin
                in_select1 <= 1; in_select2 <= 1;
            end
            else
            begin
                in_select1 <= 1; in_select2 <= 0;
            end
        end
        else
        begin
            on1 <= 1;
            on2 <= 0;
            if (stopp == 0)
            begin
                in_select1 <= 1; in_select2 <= 1;
            end
            else
            begin
                in_select1 <= 0; in_select2 <= 1;
            end
        end

        if (stopp == 1)
        begin
            en1 <= 1'b0;
            en2 <= 1'b0;
        end
        else 
        begin
            if (btn1 == 1'b1)
            begin
                en1 <= 1'b0;
                en2 <= 1'b1;
            end
            if (btn2 == 1'b1)
            begin
                en1 <= 1'b1;
                en2 <= 1'b0;
            end
        end
    end
    Clock_Normal clock1(clk, en1, on1, btnC, btnU, btnR, btnUd, btnRd, seg, select);
    Clock_Normal clock2(clk, en2, on2, btnC, btnU, btnR, btnUd, btnRd, segO, selectO);

endmodule
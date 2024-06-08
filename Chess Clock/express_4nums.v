module express_4nums (
    input clk,
    input clr,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input [3:0] in4,
    output reg [6:0] seg,
    output reg [3:0] select
);
    wire [6:0] seg1, seg2, seg3, seg4;
    localparam N = 13;
    localparam LEFT = 2'b00, MIDLEFT = 2'b01, MIDRIGHT = 2'b10, RIGHT = 2'b11;
    reg [N-1:0] count; // the 18 bit counter which can allow us to multiplex at 1000Hz
    always @(posedge clk or posedge clr)
    begin
        if (clr) count <= 0;
        else count = count + 1;
    end

    always @(*)
    begin
        case(count[N-1:N-2]) // using only 2 MSB bits of the counter
            LEFT:
            begin
                seg = seg1;
                select = 4'b1000;
            end
            MIDLEFT:
            begin
                seg = seg2;
                select = 4'b0100;
            end
            MIDRIGHT:
            begin
                seg = seg3;
                select = 4'b0010;
            end
            RIGHT:
            begin
                seg = seg4;
                select = 4'b0001;
            end
        endcase
    end

    Seven_segments dis1(in1, seg1);
    Seven_segments dis2(in2, seg2);
    Seven_segments dis3(in3, seg3);
    Seven_segments dis4(in4, seg4);

endmodule
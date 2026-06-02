`timescale 1ns / 1ps

module regfileneg(
    input [4:0] A1,A2,A3,
    input clk, WE3,
    output [31:0] RD1,RD2,
    input [31:0] WD3
    );
    reg [31:0] reglist [0:31];
    initial begin
        $readmemh("regfile.mem",reglist);
    end
    always @ (negedge clk)begin
        if(WE3 && A3!=0)begin
            reglist[A3]<=WD3;
        end
    end
    assign RD1 = (A1==0)?32'b0 : reglist[A1];
    assign RD2 = (A2==0)?32'b0 : reglist[A2];
endmodule

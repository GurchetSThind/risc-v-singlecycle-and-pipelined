`timescale 1ns / 1ps

module datamem(
    input [31:0] A, WD,
    input clk, WE,
    output reg [31:0] RD
    );
    reg [31:0] datalist [0:31];
    initial begin
        $readmemh("data.mem",datalist);
    end
    always @ (posedge clk)begin
        if(WE)begin
            datalist[A[7:2]]<=WD;
        end
    end
    always @ (*)begin
        if(!WE)begin
            if (A[1:0]==2'b00)begin
                RD=datalist[A[7:2]];
            end else begin
                RD=0; 
            end
        end
    end
endmodule

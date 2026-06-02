`timescale 1ns / 1ps

module progcounter(
    input clk, ena, rst,
    input [31:0] pcnext,
    output reg [31:0] pc
    );
    always @ (posedge clk or posedge rst) begin
        if (rst) pc<=0;
        else if (ena) pc<=pcnext;
    end
endmodule

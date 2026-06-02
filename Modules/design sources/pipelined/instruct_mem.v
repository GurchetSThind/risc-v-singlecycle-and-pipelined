`timescale 1ns / 1ps

module instruct_mem(
    input [31:0] A,
    output [31:0] RD
    );
    reg [31:0] instr_set [0:23];
    initial begin
        $readmemh("instrfile.mem",instr_set);
    end
    assign RD = instr_set [A[9:2]];
endmodule

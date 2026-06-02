`timescale 1ns / 1ps

module beqadder(
    input eq, beq,
    input [31:0] pc, imm,
    output [31:0] pcupdated
    );
    assign pcupdated = (eq&&beq)?(pc+imm):pc;
endmodule

`timescale 1ns / 1ps

module ALU(
    input [31:0] srcA, srcB, 
    input [2:0] ALUctrl,
    output [31:0] result,
    output eq
    );
    assign result =(ALUctrl==3'b001)?(srcA - srcB):
    (ALUctrl==3'b010)?(srcA&srcB):
    (ALUctrl==3'b011)?(srcA|srcB):(srcA + srcB);
    wire eqchk=(srcA==srcB);
    assign eq=eqchk; 
endmodule

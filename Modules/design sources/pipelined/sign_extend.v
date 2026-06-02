`timescale 1ns / 1ps

module sign_extend(
    input [31:0] instr,
    input [1:0] extendctrl,
    output [31:0] extendimm
    );
    assign extendimm = (extendctrl==2'b01)?{{20{instr[31]}},instr[31:20]}:
    (extendctrl==2'b10)?{{19{instr[31]}},instr[31], instr[7], instr[30:25], instr[11:8], 1'b0 }:
    {{20{instr[31]}},instr[31:25],instr[11:7]};
endmodule

`timescale 1ns / 1ps

module ControlUnit(
    input [6:0] opcode, funct7,
    input [2:0] funct3,
    output WE3, ALUBsel, WEmem, WDsel, beq,
    output [2:0] ALUCtrl,
    output[1:0] extendctrl
    ); 
    assign WE3=(opcode==7'b0000011||opcode==7'b0110011);
    assign WEmem=(opcode==7'b0100011);
    assign WDsel=(opcode==7'b0110011);
    assign ALUBsel=(opcode==7'b0100011||opcode==7'b0000011);
    assign ALUCtrl=(opcode==7'b0110011&&funct7==7'b0100000&&funct3==3'b000)?3'b001:
    (opcode==7'b0110011&&funct7==7'b0000000&&funct3==3'b111)?3'b010:
    (opcode==7'b0110011&&funct7==7'b0000000&&funct3==3'b110)?3'b011:
    (opcode==7'b1100011)?3'b100:3'b000;
    assign extendctrl=(opcode==7'b0000011)?2'b01:
    (opcode==7'b1100011)?2'b10:2'b00;
    assign beq=(opcode==7'b1100011);
endmodule

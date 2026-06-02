`timescale 1ns / 1ps

module adderplus4(
    input [31:0] PC,
    output [31:0] PCnext
    );
    assign PCnext = PC + 32'd4;
endmodule

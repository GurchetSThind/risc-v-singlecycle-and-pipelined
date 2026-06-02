`timescale 1ns / 1ps

module hazard_unit(
    input [4:0] srcreg1,srcreg2,destregM, destregW,srcreg1d,srcreg2d,destregE,
    input regwriteM, regwriteW,lw,
    output [1:0] srcAsel, srcBsel,
    output stall
    );
    assign srcAsel=(destregM==srcreg1 && regwriteM)?2'b10:
    (destregW==srcreg1 && regwriteW)?2'b01:2'b00;
    assign srcBsel=(destregM==srcreg2 && regwriteM)?2'b10:
    (destregW==srcreg2 && regwriteW)?2'b01:2'b00; 
    assign stall=(lw && (srcreg1d==destregE || srcreg2d==destregE) && destregE)?1'b1:1'b0;
endmodule 

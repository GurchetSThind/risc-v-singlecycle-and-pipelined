`timescale 1ns / 1ps

module top(
    input clk, ena, rst
    );
    wire [31:0] PCnext;
    wire [31:0] PC;
    wire [31:0] pcupdated;
    wire [31:0] pc_in;
    wire eq,beq;
    assign pc_in = (beq && eq) ? pcupdated : PCnext;
    progcounter pc1(
        .clk(clk),
        .ena(ena),
        .rst(rst),
        .pc(PC),
        .pcnext(pc_in)
    );
    
    adderplus4 pcadd(
        .PC(PC),
        .PCnext(PCnext)
    );
    wire [31:0] RDInstr;
    
    instruct_mem instrmem(
        .A(PC),
        .RD(RDInstr)
    );
    wire regwrite,memwrite,WDsel,ALUBsel;
    wire [2:0] ALUCtrl;
    wire [1:0] extendctrl;
    ControlUnit ctrl(
        .opcode(RDInstr[6:0]),
        .funct7(RDInstr[31:25]),
        .funct3(RDInstr[14:12]),
        .WE3(regwrite),
        .WEmem(memwrite),
        .ALUCtrl(ALUCtrl),
        .WDsel(WDsel),
        .ALUBsel(ALUBsel),
        .extendctrl(extendctrl),
        .beq(beq)
    );
    wire [31:0] RD1reg;
    wire [31:0] RD2reg;
    wire [31:0] RDData;
    wire [31:0] ALUres;
    regfile regfile(
        .A1(RDInstr[19:15]),
        .A2(RDInstr[24:20]),
        .A3(RDInstr[11:7]),
        .clk(clk),
        .WE3(regwrite),
        .RD1(RD1reg),
        .RD2(RD2reg),
        .WD3(WDsel?ALUres:RDData)
    );
    wire [31:0] immext;

    sign_extend immextndr(
        .instr(RDInstr),
        .extendimm(immext),
        .extendctrl(extendctrl)
    );
    wire [31:0] ALUsrcB;
    assign ALUsrcB=ALUBsel?immext:RD2reg;
    ALU ALU(
        .srcA(RD1reg),
        .srcB(ALUsrcB),
        .result(ALUres),
        .ALUctrl(ALUCtrl),
        .eq(eq)
    );
    
    beqadder beqadder(
        .eq(eq),
        .beq(beq),
        .imm(immext),
        .pc(PC),
        .pcupdated(pcupdated)
    );
    datamem datamem(
        .clk(clk),
        .A(ALUres),
        .WE(memwrite),
        .WD(RD2reg),
        .RD(RDData)
    );
endmodule

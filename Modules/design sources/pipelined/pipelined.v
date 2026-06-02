`timescale 1ns / 1ps

module pipelined(
    input clk, ena, rst,
    output beqsig,eqsig,
    output [31:0] srca,srcb,prog,
    output [2:0] aluctr,
    output stalled
    );
    wire [31:0] PCnext;
    wire [31:0] PC;
    wire [31:0] pcupdated;
    wire [31:0] pc_in;
    wire eq,beq;
    wire stall;
    reg beq_1;
    assign pc_in = (beq_1&eq) ? pcupdated : PCnext;
    progcounter pc1(
        .clk(clk),
        .ena(~stall),
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
    reg [31:0] reginstr,reginstr2, regpc;
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            reginstr<=0;
            regpc<=0;
        end else if (ena) begin
            if(beq_1&eq)begin
                reginstr<=0;
                regpc<=0;
            end else if(~stall) begin
                reginstr<=RDInstr;
                regpc<=PC;
            end
        end
    end
    assign prog=regpc;
    wire regwrite,memwrite,WDsel,ALUBsel;
    wire [2:0] ALUCtrl;
    wire [1:0] extendctrl;
    ControlUnit ctrl(
        .opcode(reginstr[6:0]),
        .funct7(reginstr[31:25]),
        .funct3(reginstr[14:12]),
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
    
    //last stage registers
    reg WDsel_3,regwrite_3;
    reg [31:0] ALUres_2,Datamemreg;
    reg [4:0] RdF;
    
    regfileneg regfile(
        .A1(reginstr[19:15]),
        .A2(reginstr[24:20]),
        .A3(RdF),
        .clk(clk),
        .WE3(regwrite_3),
        .RD1(RD1reg),
        .RD2(RD2reg),
        .WD3(WDsel_3?ALUres_2:Datamemreg)
    );
    wire [31:0] immext;

    sign_extend immextndr(
        .instr(reginstr),
        .extendimm(immext),
        .extendctrl(extendctrl)
    );
    reg [31:0] regpc_1, regRD1, regRD2,regimmext;
    reg [4:0] RdD,Rsrc1,Rsrc2;
    reg regwrite_1,memwrite_1,WDsel_1,ALUBsel_1;
    reg [2:0] ALUCtrl_1;
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            regpc_1<=0;
            reginstr2<=0;
            Rsrc2<=0;
            Rsrc1<=0;
            regRD1<=0;
            regRD2<=0;
            regimmext<=0;
            regwrite_1<=0;
            memwrite_1<=0;
            WDsel_1<=0;
            ALUBsel_1<=0;
            beq_1<=0;
            ALUCtrl_1<=0;
            RdD<=0;
        end else if (ena) begin
            if((beq_1 & eq)||stall)begin
                regpc_1<=0;
                regRD1<=0;
                regRD2<=0;
                reginstr2<=0;
                regimmext<=0;
                regwrite_1<=0;
                memwrite_1<=0;
                Rsrc2<=0;
                Rsrc1<=0;
                WDsel_1<=0;
                ALUBsel_1<=0;
                beq_1<=0;
                ALUCtrl_1<=0;
                RdD<=0;
            end else begin
                regpc_1<=regpc;
                regRD1<=RD1reg;
                regRD2<=RD2reg;
                reginstr2<=reginstr;
                Rsrc2<=reginstr[24:20];
                Rsrc1<=reginstr[19:15];
                regimmext<=immext;
                regwrite_1<=regwrite;
                memwrite_1<=memwrite;
                WDsel_1<=WDsel;
                ALUBsel_1<=ALUBsel;
                beq_1<=beq;
                ALUCtrl_1<=ALUCtrl;
                RdD<=reginstr[11:7];
            end
        end
    end
    wire [31:0] ALUsrcB;
    reg[31:0] ALUres_1;
    wire [1:0] srcAsel,srcBsel;
    assign ALUsrcB=ALUBsel_1?regimmext:regRD2;
    wire [31:0] SA,SB;
    wire [31:0] WD3;
    assign WD3=WDsel_3?ALUres_2:Datamemreg;
    assign SA =(srcAsel==2'b01)?WD3:
     (srcAsel==2'b10)?ALUres_1:regRD1;
     assign SB =(srcBsel==2'b01)?WD3:
     (srcBsel==2'b10)?ALUres_1:ALUsrcB;
    ALU ALU(
        .srcA(SA), 
        .srcB(ALUsrcB),
        .result(ALUres),
        .ALUctrl(ALUCtrl_1),
        .eq(eq)
    );
    assign aluctr=ALUCtrl_1;
    assign srca=regRD1;
    assign srcb=ALUsrcB;
    beqadder beqadder(
        .eq(eq),
        .beq(beq_1),
        .imm(regimmext),
        .pc(regpc_1),
        .pcupdated(pcupdated)
    );
    reg [4:0] RdE;
    reg [31:0] regRD2_1;
    reg regwrite_2,WDsel_2,memwrite_2;
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            regRD2_1<=0;
            ALUres_1<=0;
            regwrite_2<=0;
            memwrite_2<=0;
            WDsel_2<=0;
            RdE<=0;
        end else if (ena) begin
            regRD2_1<=regRD2;
            ALUres_1<=ALUres;
            regwrite_2<=regwrite_1;
            memwrite_2<=memwrite_1;
            WDsel_2<=WDsel_1;
            RdE<=RdD;
        end
    end
    datamem datamem(
        .clk(clk),
        .A(ALUres_1),
        .WE(memwrite_2),
        .WD(regRD2_1),
        .RD(RDData)
    );
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            Datamemreg<=0;
            ALUres_2<=0;
            regwrite_3<=0;
            WDsel_3<=0;
            RdF<=0;
        end else if (ena) begin
            Datamemreg<=RDData;
            ALUres_2<=ALUres_1;
            regwrite_3<=regwrite_2;
            WDsel_3<=WDsel_2;
            RdF<=RdE;
        end
    end
    wire lw;
    assign lw=reginstr2[6:0]==7'b0000011 && reginstr2[14:12]==3'b010;
    assign beqsig=beq_1;
    assign eqsig=eq;
    hazard_unit hu(
        .srcreg1(Rsrc1),
        .srcreg2(Rsrc2),
        .destregM(RdE),
        .destregW(RdF),
        .srcreg1d(reginstr[19:15]),
        .srcreg2d(reginstr[24:20]),
        .destregE(RdD),
        .regwriteM(regwrite_2),
        .regwriteW(regwrite_3),
        .lw(lw),
        .srcAsel(srcAsel),
        .srcBsel(srcBsel),
        .stall(stall)
    );
    assign stalled=stall;
endmodule

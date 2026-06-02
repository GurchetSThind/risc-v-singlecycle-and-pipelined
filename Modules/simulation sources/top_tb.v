`timescale 1ns / 1ps

module top_tb(

    );
    reg rst;
    reg clk;
    top topbox(
        .clk(clk),
        .ena(1'b1),
        .rst(rst)
    );
    integer i;
    initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst = 1'b1;
    repeat (3) @(posedge clk);
    rst = 1'b0;
  end

  initial begin
    repeat (40) @(posedge clk);

    for (i = 0; i < 32; i = i + 1) begin
      $display("[t=%0t] x%0d = 0x%08x", $time, i, top_tb.topbox.regfile.reglist[i]);
    end
    for (i = 0; i < 32; i = i + 1) begin
      $display("[t=%0t] x%0d = 0x%08x", $time, i, top_tb.topbox.datamem.datalist[i]);
    end
    $finish;
  end


endmodule

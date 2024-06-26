`timescale 10ns / 1ns

module tb_top;

logic [31:0] tb_muxOut, tb_aluIn, tb_aluOut, tb_immOut, tb_pc, tb_memload, tb_writeData, tb_regData1, tb_regData2;
logic [5:0] tb_cuOP;
logic [4:0] tb_regsel1, tb_regsel2, tb_w_reg;
logic [3:0] tb_aluOP;
logic [19:0] tb_imm;
logic clk, nrst, tb_zero, tb_negative;

parameter CLK_PER = 10;
//always #(CLK_PER/2) clk ++;
always begin 
clk = 1'b0;
#(CLK_PER / 2.0);
clk = 1'b1;
#(CLK_PER / 2.0);
end


top DUT(.clk(clk), .nrst(nrst), .memload(tb_memload), .aluIn(tb_aluIn), .aluOut(tb_aluOut), .immOut(tb_immOut), 
.pc(tb_pc), .writeData(tb_writeData), .zero(tb_zero), .negative(tb_negative), .cuOP(tb_cuOP));

task reset_dut;
  @(negedge clk);
  nrst = 1'b0; 
  @(negedge clk);
  @(negedge clk);
  nrst = 1'b1;
  @(posedge clk);
endtask

initial begin
$dumpfile("dump.vcd");
$dumpvars; 



//ADDI x1, x0, 1000
@(negedge clk);
@(posedge clk);
@(negedge clk);
@(posedge clk);
@(negedge clk);
@(posedge clk);
@(negedge clk);
@(posedge clk);
@(negedge clk);
@(posedge clk);
@(negedge clk);
@(posedge clk);
@(negedge clk);
@(posedge clk);
@(negedge clk);
@(posedge clk);
@(negedge clk);
@(posedge clk);
#1;
$finish;
end

endmodule
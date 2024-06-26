`timescale 10ns / 1ns

module tb_top;

logic [31:0] tb_instruction, tb_muxOut, tb_aluIn, tb_aluOut, tb_immOut, tb_pc, tb_memload, tb_writeData, tb_regData1, tb_regData2;
logic [5:0] tb_cuOP;
logic [4:0] tb_regsel1, tb_regsel2, tb_w_reg;
logic [3:0] tb_aluOP;
logic [19:0] tb_imm;
logic clk, nrst, tb_zero, tb_negative;

parameter CLK_PER = 10;
always #(CLK_PER/2) clk ++;

top DUT(.clk(clk), .nrst(nrst), .instruction(tb_instruction), .memload(tb_memload), .muxOut(tb_memload), .aluIn(tb_aluIn), .aluOut(tb_aluOut), .immOut(tb_immOut), 
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

reset_dut;

//ADDI x1, x0, 1000
@(negedge clk);
tb_instruction = 32'h3e800093;

//addi x2, x0, -2000
#(CLK_PER *1);
@(negedge clk);
tb_instruction = 32'h83000113;

//ori x3 , x0,  1001
#(CLK_PER *1);
@(negedge clk);
tb_instruction = 32'h3e906193;

//andi x4 , x0,  1111
#(CLK_PER *1);
@(negedge clk);
tb_instruction = 32'h45707213;

//andi x4, x3, 1011
#(CLK_PER *1);
@(negedge clk);
tb_instruction = 32'h3f31f213;
end

endmodule
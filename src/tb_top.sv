`timescale 10ns / 1ns

module tb_top;

logic [31:0] tb_instruction, tb_aluIn, tb_aluOut, tb_immOut, tb_pc, tb_memload, tb_writeData, tb_regData1, tb_regData2;
logic [5:0] tb_cuOP;
logic [4:0] tb_regsel1, tb_regsel2, tb_w_reg;
logic [3:0] tb_aluOP;
logic [19:0] tb_imm;
logic clk, nrst, tb_zero, tb_negative, tb_aluSrc;

parameter CLK_PER = 10;
//always #(CLK_PER/2) clk ++;
always begin 
clk = 1'b0;
#(CLK_PER / 2.0);
clk = 1'b1;
#(CLK_PER / 2.0);
end

top DUT(.clk(clk), .nrst(nrst), .instruction(tb_instruction), .memload(tb_memload), .aluIn(tb_aluIn), .aluOut(tb_aluOut), .immOut(tb_immOut), 
.pc(tb_pc), .writeData(tb_writeData), .zero(tb_zero), .negative(tb_negative), .cuOP(tb_cuOP), .regsel1(tb_regsel1), .regsel2(tb_regsel2), .w_reg(tb_w_reg), .imm(tb_imm), .regData1(tb_regData1), .regData2(tb_regData2), .aluOP(tb_aluOP), .aluSrc(tb_aluSrc));

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

@(negedge clk);

//I type instructions 
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

//Branch Instructions
reset_dut;

//addi x1 , x0,   1000
#(CLK_PER *1);
@(negedge clk);
tb_instruction = 32'h3e800093;

//addi x2 , x0,   2000
#(CLK_PER *1);
@(negedge clk);
tb_instruction = 32'h7d000113;

//addi x3 , x0,  -1000
#(CLK_PER *1);
@(negedge clk);
tb_instruction = 32'hc1800193;

//addi x4, x0,  1000
#(CLK_PER *1);
@(negedge clk);
tb_instruction = 32'h3e800213;

//addi x5, x0, 	-500
#(CLK_PER *1);
@(negedge clk);
tb_instruction = 32'he0c00293;

//no branch, PC + 4 
//beq x2, x1, 1000 
#(CLK_PER *1);
@(negedge clk);
tb_instruction = 32'h00111463;
#(CLK_PER *1);
@(negedge clk);
tb_instruction = 32'h3e40006f; 

//Branch, PC + imm
//bne x3, x2, 2000
#(CLK_PER *1);
@(negedge clk);
tb_instruction = 32'h00218463;
#(CLK_PER *1);
@(negedge clk);
tb_instruction = 32'h7cc0006f; 

#(CLK_PER *2);
$finish;
end

endmodule
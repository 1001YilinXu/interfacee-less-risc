`timescale 1ms / 10ns

module tb_top;

typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR
	} cuOPType;


logic [31:0] tb_instruction, tb_muxOut, tb_aluIn, tb_aluOut, tb_immOut, tb_pc, tb_memload, tb_writeData, tb_regData1, tb_regData2;
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


top DUT(.clk(clk), .nrst(nrst), .instruction(tb_instruction), .memload(tb_memload), .aluIn(tb_aluIn), .aluOut(tb_aluOut), .immOut(tb_immOut), 
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

nrst = 1'b1;
tb_instruction = 32'b0;

reset_dut;

@(negedge clk);


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

#1;
$finish;
end

endmodule
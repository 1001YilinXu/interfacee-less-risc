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


logic [31:0] tb_instruction, tb_aluIn, tb_aluOut, tb_immOut, tb_pc, tb_memload, tb_writeData, tb_regData1, tb_regData2;
logic [5:0] tb_cuOP;
logic [4:0] tb_regsel1, tb_regsel2, tb_w_reg;
logic [3:0] tb_aluOP;
logic [19:0] tb_imm;
logic clk, nrst, tb_zero, tb_negative, tb_aluSrc;
logic tb_memWrite, tb_memRead;

parameter CLK_PER = 10;
//always #(CLK_PER/2) clk ++;
always begin 
clk = 1'b0;
#(CLK_PER / 2.0);
clk = 1'b1;
#(CLK_PER / 2.0);
end

top DUT(.clk(clk), .nrst(nrst), .instruction(tb_instruction), .memload(tb_memload), .aluIn(tb_aluIn), .aluOut(tb_aluOut), .immOut(tb_immOut), 
.pc(tb_pc), .writeData(tb_writeData), .zero(tb_zero), .negative(tb_negative), .cuOP(tb_cuOP), .regsel1(tb_regsel1), .regsel2(tb_regsel2), .w_reg(tb_w_reg),
 .imm(tb_imm), .regData1(tb_regData1), .regData2(tb_regData2), .aluOP(tb_aluOP), .aluSrc(tb_aluSrc), .memWrite(tb_memWrite), .memRead(tb_memRead));

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

    //bne branch
      //bne x2, x1, loop
      //beq x2, x1, 1000 
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h00111263;
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h3e808313; 

    //bne not branch
      //bne x1, x1, loop
      //beq x2, x1, 1000 
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h0010963;
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h3e808313; 

    //bge branch
      //equal
      //bge x1, x1, loop
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h0010d263;
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h3e808313;
      //greater than
      //bge x2, x1, loop
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h00115263;
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h3e808313;

    //bge no branch
      //bge x1, x2, loop
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h0020d263;
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h3e808313;

    //beq no branch
      //beq x1, x3, loop
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h00308263;
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h3e808313;

    //beq branch
      //beq x1, x1, loop
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h00108263;
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h3e808313;

    //blt branch
      //blt x3, x1, loop
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h0011c263;
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h3e808313;

    //blt no branch
      //blt x2, x1, loop
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h00114263;
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h3e808313;

    //CUTT
    // //bltu Branch 
    //   //different sign **
    //   //bltu x1, x3, loop  
    //     #(CLK_PER *1);
    //     @(negedge clk);
    //     tb_instruction = 32'h0030e263;
    //     #(CLK_PER *1);
    //     @(negedge clk);
    //     tb_instruction = 32'h3e808313;
    //   //same sign
    //   //bltu x1, x2, loop  
    //     #(CLK_PER *1);
    //     @(negedge clk);
    //     tb_instruction = 32'h0020e263;
    //     #(CLK_PER *1);
    //     @(negedge clk);
    //     tb_instruction = 32'h3e808313;

    // //bltu no branch
    //   //different signs **
    //   //bltu x3, x1, loop  
    //     #(CLK_PER *1);
    //     @(negedge clk);
    //     tb_instruction = 32'h0011e263;
    //     #(CLK_PER *1);
    //     @(negedge clk);
    //     tb_instruction = 32'h3e808313;
    //   //same signs
    //   //bltu x2, x1, loop  
    //     #(CLK_PER *1);
    //     @(negedge clk);
    //     tb_instruction = 32'h00116263;
    //     #(CLK_PER *1);
    //     @(negedge clk);
    //     tb_instruction = 32'h3e808313;

    // //bgeu branch equal 
    //   //bgeu x1, x1, loop
    //   #(CLK_PER *1);
    //   @(negedge clk);
    //   tb_instruction = 32'h0010f263;
    //   #(CLK_PER *1);
    //   @(negedge clk);
    //   tb_instruction = 32'h3e808313; 

    // //bgeu branch equal, opposite signs
    //   //bgeu x1, x3, loop
    //   #(CLK_PER *1);
    //   @(negedge clk);
    //   tb_instruction = 32'h0030f263;
    //   #(CLK_PER *1);
    //   @(negedge clk);
    //   tb_instruction = 32'h3e808313; 

//Jump Instructions
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

    //addi x5, x0, 	-500
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'he0c00293;
    
  //not working
  //jal 
    //jal x0, loop
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h7d000093;

  //working
  //jalr 
      //jalr x8, x0, 1000
      #(CLK_PER *1);
      @(negedge clk);
      tb_instruction = 32'h7d0000ef;

  //working
  //lui
    //lui x1, 2000
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h007d00b7;

  //AUIPC
    

//I type instrucitons
  reset_dut;
  //addi
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h0aa00193;
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h0ff00213;
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'hf0100293;

  //xori
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h3f204293;
  //slti
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'hc1802313;
  //sltiu
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'hc1803393;
  //slli
  //slli x8, x3, 5
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h00519413;
  //srli
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h0051d493;
  //srai
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h4051d493;

//testing R type
  reset_dut;
  //addi
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h0aa00193;
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h0ff00213;
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'hf0100293;
  //addi
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h00300093;

  //add
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h00300533;
  //sub 
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h403005b3;
  //xor
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h00324633;
  //or
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h003266b3;
  //and
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h00327733;
  //slt
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h0041a7b3;
  //sltu
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h0051b833;

  //sll
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h005198b3;

  //srl
  //srl x18, x4, x3
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h00325933;
    
  //srl
  //srl x18, x4, x5
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h00525933;

  //srl
  //srl x18, x4, x4
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h00425933;

 //sra
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h4011d933;

//testing load and store type
  reset_dut;
    //addi
    //addi x1, x0, 100
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h06400093;

    //lw
    //lw x1, 0(x2)
    #(CLK_PER *1);
    @(negedge clk);
    tb_instruction = 32'h00012083;





#(CLK_PER *2);
$finish;
end

endmodule
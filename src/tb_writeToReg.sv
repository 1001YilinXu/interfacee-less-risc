
`timescale 1ms / 100us
 
module writeToReg_tb ();
 
writeToReg DUT(.memload(tb_memload), .PC(tb_PC), .linkReg(tb_linkReg), .aluOut(tb_aluOut),
.imm(tb_imm), .writeData(tb_writeData), .ALUneg(tb_ALUneg), .cuOP(tb_cuOP));
 
logic [31:0] tb_memload, tb_PC, tb_linkReg, tb_aluOut, tb_imm, tb_writeData;
logic tb_ALUneg, tb_checking_outputs;
logic [5:0] tb_cuOP;
integer tb_numOfTests, tb_intermResult;
string = tb_test_case;
 
 
 
 
localparam CLK_PERIOD = 10;
 
logic tb_clk;
 
always begin
    tb_clk = 1'b0;
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1;
    #(CLK_PERIOD / 2.0);
end
 
task reset_dut;
    @(negedge tb_clk);
    tb_nRST = 1'b0;
    @(negedge tb_clk);
    tb_nRST = 1'b1;
    @(posedge tb_clk);
endtask
 
task checkOut;
    input logic [31:0] exp_out;
    @(negedge tb_clk);
    tb_checking_outputs = 1'b1;
    if(tb_writeData == exp_out)
        $info("Correct value to write %0d.", exp_out);
    else
        $error("Incorrect value to write. Expected: %0d. Actual: %0d.", exp_out, tb_writeData);
    #(1);
    tb_checking_outputs = 1'b0;  
endtask
 
initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    tb_memload = 32'b0;
    tb_PC = 32'b0;
    tb_linkReg = 32'b0;
    tb_aluOut = 32'b0;
    tb_imm = 32'b0;
    tb_ALUNeg = 0;
    tb_cuOP = 6'b0;
    tb_writeData = 32'b0;
    tb_numOfTests = 100;
    tb_test_num = -1;
    tb_test_case = "Initializing";
    tb_intermResult = 0;
	// ************************************************************************
  // Test Case 0: Power-on-Reset of the DUT
  // ************************************************************************
        //Check to see if reset address is correct
        tb_test_num += 1;
        tb_test_case = "Test Case 0: Power-on-Reset of the DUT";
        $display("\n\n%s", tb_test_case);
        tb_nRST = 0;
        #2;
        checkOut(32'b0);
        @(negedge tb_clk);
        tb_nRST = 1;
 	// ************************************************************************
  // Test Case 1: Test LB case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 1: Testing LB";
			tb_memload = 32'haaaaaaaa;
			tb_pc = 32'hbbbbbbbb;
			tb_cuOP = CU_LB;
			#2;
			checkOut(32'b1111_1111_1111_1111_1111_1111_1010_1010);
			#5;
	// ************************************************************************
  // Test Case 2: Test LH case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 2: Testing LH";
			tb_memload = 32'hbbbbbaba;
			tb_pc = 32'hbbbbbbbb;
			tb_cuOP = CU_LH;
			#2;
			checkOut(32'b1111_1111_1111_1111_1011_1010_1011_1010);
			#5;
	// ************************************************************************
  // Test Case 3: Test LW case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 3: Testing LW";
			tb_memload = 32'habababab;
			tb_pc = 32'hbbbbbbbb;
			tb_cuOP = CU_LW;
			#2;
			checkOut(32'b1010_1011_1010_1011_1010_1011_1010_1011);
			#5;
	// ************************************************************************
  // Test Case 4: Test LBU case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 4: Testing LBU";
			tb_memload = 32'haaaaaaaa;
			tb_pc = 32'hbbbbbbbb;
			tb_cuOP = CU_LBU;
			#2;
			checkOut({24'b0, 1010_1010});
			#5;
	// ************************************************************************
  // Test Case 5: Test LHU case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 5: Testing LHU";
			tb_memload = 32'hbbbbbbbb;
			tb_pc = 32'hbbbbbbbb;
			tb_cuOP = CU_LHU;
			#2;
			checkOut({16'b0, 1011, 1011, 1011, 1011});
			#5;
	// ************************************************************************
  // Test Case 6: Test AUIPC case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 6: Testing AUIPC";
			tb_memload = 32'hbbbbbbbb;
			tb_pc = 32'hbbbbbbbb;
			tb_imm = 32'd10;
			tb_cuOP = CU_AUIPC;
			#2;
			//check that the checkout is correct, is should the immediate be 31:12 or 19:0?
			checkOut({tb_imm[31:12], 12'b0} + tb_pc);
			#5;
	// ************************************************************************
  // Test Case 7: Test LUI case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 7: Testing LUI";
			tb_memload = 32'hbbbbbbbb;
			tb_pc = 32'hbbbbbbbb;
			tb_imm = 32'd10;
			tb_cuOP = CU_LUI;
			#2;
			//check that the checkout is correct, is should the immediate be 31:12 or 19:0?
			checkOut({tb_imm[31:12], 12'b0});
			#5;
	// ************************************************************************
  // Test Case 8: Test JAL case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 8: Testing JAL";
			tb_memload = 32'hbbbbbbbb;
			tb_pc = 32'hbbbbbbbb;
			tb_imm = 32'd10;
			tb_cuOP = CU_JAL;
			#2;
			//check that the checkout is correct, is should the immediate be 31:12 or 19:0?
			checkOut(tb_pc + 4);
			#5;
	// ************************************************************************
  // Test Case 9: Test JALR case
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 9: Testing JALR";
			tb_memload = 32'hbbbbbbbb;
			tb_pc = 32'hbbbbbbbb;
			tb_imm = 32'd10;
			tb_cuOP = CU_JALR;
			#2;
			//check that the checkout is correct, is should the immediate be 31:12 or 19:0?
			checkOut(tb_pc + 4);
			#5;
	// ************************************************************************
  // Test Case 10: Checking other OPs
  // ************************************************************************
			tb_test_num += 1;
      tb_test_case = "Test Case 9: Testing JALR";
			tb_memload = 32'hbbbbbbbb;
			tb_pc = 32'hbbbbbbbb;
			tb_imm = 32'd10;
			tb_cuOP = CU_ADD;
			#2;
			checkOut(tb_aluOut);
			#5;
			tb_cuOP = CU_XOR;
			#2;
			checkOut(tb_aluOut);
			#5;
			tb_cuOP = CU_SB;
			#2;
			checkOut(tb_aluOut);
			#5;
#1;
    $finish;
end
 
 
endmodule
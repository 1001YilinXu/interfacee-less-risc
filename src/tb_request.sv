`timescale 1ms / 100us
typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR
	} cuOPType;	
module tb_request();
   localparam CLK_PERIOD = 10;

     logic tb_clk, tb_nRST, tb_Ren, tb_Wen, tb_busy_o;
     logic [31:0] tb_ramaddr, tb_ramstore, tb_ramload;
     logic [31:0] tb_imemload, tb_dmmload, tb_imemaddr, tb_dmmaddr, tb_dmmstore;
     cuOPType tb_cuOP; 


    
    request DUT(.CLK(tb_clk), .nRST(tb_nRST), .busy_o(tb_busy_o),
                .imemaddr(tb_imemaddr), .dmmaddr(tb_dmmaddr), .dmmstore(tb_dmmstore), .ramload(tb_ramload),
                .cuOP(tb_cuOP), .Ren(tb_Ren), .Wen(tb_Wen), .imemload(tb_imemload), .dmmload(tb_dmmload), .ramaddr(tb_ramaddr), .ramstore(tb_ramstore));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        tb_nRST = 0; 
        tb_busy_o = 0;
        tb_imemaddr = 0;
        tb_dmmaddr = 0;
        tb_dmmstore = 0;
        tb_ramload = 0;
        tb_cuOP = CU_LB;

        #(CLK_PERIOD)
        #(CLK_PERIOD)

        tb_nRST = 1;
        tb_busy_o = 1;
        tb_imemaddr = 32'habcdabcd;
        tb_ramload = 32'h12341234;

        #(CLK_PERIOD)
        tb_dmmaddr = 32'h56785678;
        tb_ramload = 32'h43214321;

        #(CLK_PERIOD)

        tb_imemaddr = 32'h11111111;
        tb_ramload = 32'h22222222;
        
        tb_cuOP = CU_SW;
        #(CLK_PERIOD)

        tb_dmmstore = 32'h33333333;
        tb_dmmaddr = 32'habcdabcd;

        #(CLK_PERIOD)
        tb_imemaddr = 32'h12121212;
        tb_ramload = 32'h23232323;




    end

endmodule
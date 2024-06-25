//input 32 bits imemload 
// output read_reg1, read_reg2, writeReg - 5 bits, 
// Cuop - 6 bits. 
// Aluop - 4 bits
// regwrite, Alusrc 1 bit 
// imm 20 bits 

`include "src/control.sv"

`timescale 1 ms/ 100us

module tb_control();
logic [31:0] tb_instructions;
logic [4:0] tb_reg_1, tb_reg_2, tb_rd;
logic [19:0] tb_imm;
logic [3:0] tb_aluOP;
cuOPType tb_cuOP;
logic tb_regWrite, tb_memWrite, tb_memRead, tb_aluSrc;

parameter PERIOD = 10;
controller DUT (.cuOP(tb_cuOP), .instruction(tb_instructions), 
.reg_1(tb_reg_1), .reg_2(tb_reg_2), .rd(tb_rd),
.imm(tb_imm), .aluOP(tb_aluOP), .regWrite(tb_regWrite), .memWrite(tb_memWrite), .memRead(tb_memRead), .aluSrc(tb_aluSrc));
 
    
    initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    
        tb_instructions = 32'hAAAAA537; //Lui
         #(PERIOD)
        tb_instructions = 32'hAAAAA517; // AUIPC 
         #(PERIOD)
        tb_instructions = 32'hFACEE56F;  // JAL
        #(PERIOD)
        tb_instructions = 32'hFAC78567; // JALR
        #(PERIOD)
        tb_instructions = 32'h6EDA88E7;// BEQ
        #(PERIOD)
        tb_instructions = 32'h6EDA98E7;// BNE
        #(PERIOD)
        tb_instructions = 32'h6EDAC8E7 ;// BGE
        #(PERIOD)
        tb_instructions = 32'h6EDAD8E7; // BLTU
        #(PERIOD)
        tb_instructions = 32'h6EDAE8E7; // BEGU
        #(PERIOD)
        tb_instructions = 32'h6EDAF8E7; // BGEU
        #(PERIOD)
        tb_instructions = 32'hABCA8503; // LB
        #(PERIOD)
        tb_instructions = 32'hABCA9503 ;// LH
        #(PERIOD)
        tb_instructions = 32'hABCAA503; // LW
        #(PERIOD)
        tb_instructions = 32'hABCAC503 ;// LBU
        #(PERIOD)
        tb_instructions = 32'hABCAD503; // LHU
        #(PERIOD)
        tb_instructions = 32'hEEAC0723 ;// SB
        #(PERIOD)
        tb_instructions = 32'hEEAC1723; // SH
        #(PERIOD)
        tb_instructions = 32'hEEAC2723; // SW
        #(PERIOD)
        tb_instructions = 32'hABC50D13; // ADDI
        #(PERIOD)
        tb_instructions = 32'hABC52D13; // SLTI
        #(PERIOD)
        tb_instructions = 32'hABC53D13; //SLTIU 
        #(PERIOD)
        tb_instructions = 32'hABC54D13; //XORI
        #(PERIOD)
        tb_instructions = 32'hABC56D13; //ORI
        #(PERIOD)
        tb_instructions = 32'hABC57D13; //ANDI
        #(PERIOD)
        tb_instructions = 32'h002A9C13; // SLLI
        #(PERIOD)
        tb_instructions = 32'h402D9C13; // SRLI
        #(PERIOD)
        tb_instructions = 32'h402D9C13; // SRAI
        #(PERIOD)
        tb_instructions = 32'h00C50C33; // add
        #(PERIOD)
        tb_instructions = 32'h40C50C33; // sub
        #(PERIOD)
        tb_instructions = 32'h00C51C33; // sll
        #(PERIOD)
        tb_instructions = 32'h00C52C33; // slt
        #(PERIOD)
        tb_instructions = 32'h00C53C33; // sltu
        #(PERIOD)
        tb_instructions = 32'h00C54C33; // xor
        #(PERIOD)
        tb_instructions = 32'h00C55C33; // srl
        #(PERIOD)
        tb_instructions = 32'h40C55C33; // sra
        #(PERIOD)
        tb_instructions = 32'h00C56C33; //OR
        #(PERIOD)
        tb_instructions = 32'h00C57C33; // AND

    end
endmodule
//input 32 bits imemload 
// output read_reg1, read_reg2, writeReg - 5 bits, 
// Cuop - 6 bits. 
// Aluop - 4 bits
// regwrite, Alusrc 1 bit 
// imm 20 bits 

`include "src/control.sv"

`timescale 1 ms/ 100us

module tb_control();
control DUT (.cuOp(tb_cuOP), )
 
    parameter PERIOD = 10;
    initial begin
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
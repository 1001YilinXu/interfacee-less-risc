module alu(
    input logic signed[31:0]inputA, inputB,
    input logic[5:0] aluOP,
    output logic[31:0]ALUResult,
    output logic negative, zero
);
	typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR
	} cuOPType;	

//input A and B must be signed!
logic [31:0] unsignedA, unsignedB;
assign unsignedA = inputA;
assign unsignedB = inputB;
always_comb begin
    //will this zero cause an issue?
    zero = 0;
    case (aluOP)
    CU_SLL: begin
        ALUResult = inputA << inputB[4:0];
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    CU_SRA: begin
        ALUResult = inputA >>> inputB[4:0];
        negative = ALUResult[31];
        if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    CU_SRL: begin
        ALUResult = inputA >> inputB[4:0];
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    CU_ADD: begin
        ALUResult = inputA + inputB;
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    CU_SUB: begin
        ALUResult = inputA - inputB;
        if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
        negative = ALUResult[31];
    end
    CU_OR: begin
        ALUResult = inputA | inputB;
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    CU_XOR: begin
        ALUResult = inputA ^ inputB;
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    CU_AND: begin
        ALUResult = inputA & inputB;
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    CU_SLT: begin
        if (inputA < inputB)
            ALUResult = 32'd1;
        else
            ALUResult = 32'd0; 
        negative = ALUResult[31];
    end
    CU_SLTU: begin
        if (unsignedA < unsignedB)
            ALUResult = 32'd1;
        else
            ALUResult = 32'd0;
        negative = ALUResult[31];
             end
    //do I need a defualt case?
    default: begin
        ALUResult = 32'd0;
        negative = 0;
        zero = 0;
    end
    endcase
end
endmodule   
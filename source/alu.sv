module alu(
    input logic[31:0]inputA, inputB,
    input logic[5:0] aluOP,
    output logic[31:0]ALUResult,
    output logic negative, zero
);
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
        ALUResult = inputA >> inputB;
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
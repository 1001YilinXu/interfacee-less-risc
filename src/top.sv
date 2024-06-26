// FPGA Top Level

`default_nettype none

module top (
  // I/O ports
  // input  logic hz100, reset,
  // input  logic [20:0] pb,
  // output logic [7:0] left, right,
  //        ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  // output logic red, green, blue,

  // // UART ports
  // output logic [7:0] txdata,
  // input  logic [7:0] rxdata,
  // output logic txclk, rxclk,
  // input  logic txready, rxready
	input logic clk, nrst,
	input logic [31:0]instruction,
	output logic zero, negative,  
	output logic [5:0] cuOP,
	output logic [31:0] memload, aluIn, aluOut, immOut, pc, writeData
);
logic [31:0] regData1, regData2;
logic [4:0] regsel1, regsel2, w_reg;
logic [3:0] aluOP;
logic [19:0] imm;

logic regWrite, aluSrc, i_ready, d_ready, memWrite, memRead;

// assign nrst = pb[19];
// assign clk = hz100;
// assign left[4:0] = reg_1;

mux aluMux(.in1(regData2), .in2(immOut), .en(aluSrc), .out(aluIn));

alu arith(.aluOP(cuOP), .inputA(regData1), .inputB(aluIn), .ALUResult(aluOut), .zero(zero), .negative(negative));

//request ru(.clk(clk), .nRST(nrst), .imemload(), .imemaddr(), .dmmaddr(), .dmmstore(), .ramaddr(), .ramload(), .ramstore(), .cuOP(), .Ren(), .Wen());

register_file DUT(.clk(clk), .nRST(nrst), .reg_write(regWrite), .read_index1(regsel1), .read_index2(regsel2), 
.read_data1(regData1), .read_data2(regData2), .write_index(w_reg), .write_data(writeData));

control controller (.cuOP(cuOP), .instruction(instruction), 
.reg_1(regsel1), .reg_2(regsel2), .rd(w_reg),
.imm(imm), .aluOP(aluOP), .regWrite(regWrite), .memWrite(memWrite), .memRead(memRead), .aluSrc(aluSrc));

pc testpc(.clk(clk), .nRST(nrst), .ALUneg(negative), .Zero(zero), .iready(i_ready), .PCaddr(pc), .cuOP(cuOP), .rs1Read(regData1), .signExtend(immOut));

writeToReg write(.cuOP(cuOP), .memload(memload), .aluOut(aluOut), .imm(immOut), .pc(pc), .writeData(writeData), .negative(negative));

signExtender signex(.imm(imm), .immOut(immOut), .CUOp(cuOP));
// ssdec ss1();
// ssdec ss2();
// ssdec ss3();
// ssdec ss4();
// ssdec ss5();
// ssdec ss6();
// ssdec ss7();
// ssdec ss8();
endmodule

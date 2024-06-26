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
	input logic [31:0]instruction, memload,
	output logic zero, negative,  
	output logic [5:0] cuOP,
	output logic [31:0] muxOut, aluIn, aluOut, immOut, pc, writeData
);
logic [31:0] regData1, regData2;
logic [4:0] regsel1, regsel2, w_reg;
logic [3:0] aluOP;
logic [19:0] imm;

logic regWrite, aluSrc, i_ready, d_ready;

// assign nrst = pb[19];
// assign clk = hz100;
// assign left[4:0] = reg_1;

mux aluMux(.in1(reg_2), .in2(immOut), .en(aluSrc), .out(aluIn));

alu arith(.aluOP(aluOP), .in1(reg_1), .in2(aluIn), .aluOut(aluOut), .zero(zero), .negative(negative));

//request ru(.clk(clk), .nRST(nrst), .imemload(), .imemaddr(), .dmmaddr(), .dmmstore(), .ramaddr(), .ramload(), .ramstore(), .cuOP(), .Ren(), .Wen());

register_file DUT(.clk(clk), .nRST(nrst), .reg_write(tb_WEN), .read_index1(tb_index1), .read_index2(tb_index2), 
.read_data1(read_data1), .read_data2(read_data2), .write_index(write_index), .write_data(write_data));

control controller (.cuOP(tb_cuOP), .instruction(tb_instructions), 
.reg_1(tb_reg_1), .reg_2(tb_reg_2), .rd(tb_rd),
.imm(tb_imm), .aluOP(tb_aluOP), .regWrite(tb_regWrite), .memWrite(tb_memWrite), .memRead(tb_memRead), .aluSrc(tb_aluSrc));

pc testpc(.clk(clk), .nRST(nrst), .ALUneg(negative), .Zero(zero), .iready(i_ready), .PCaddr(pc), .cuOP(cuOP), .rs1Read(reg_1), .signExtend(immOut));

writetoReg write(.cuOP(cuOP), .memload(memload), .aluOut(aluOut), .immOut(immOut), .pc(pc), .writeData(writeData));

// ssdec ss1();
// ssdec ss2();
// ssdec ss3();
// ssdec ss4();
// ssdec ss5();
// ssdec ss6();
// ssdec ss7();
// ssdec ss8();
endmodule

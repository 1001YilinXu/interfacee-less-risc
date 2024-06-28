module tb_ram;
    logic clk, tb_nRst, tb_write_enable, tb_read_enable;
    logic [4:0] tb_address_DM, tb_address_IM;
    logic [31:0] tb_data_in, tb_data_out, tb_instr_out;
    logic tb_pc_enable;

parameter CLK_PER = 10;
//always #(CLK_PER/2) clk ++;
always begin 
clk = 1'b0;
#(CLK_PER / 2.0);
clk = 1'b1;
#(CLK_PER / 2.0);
end

ram DUT(.clk(clk), .nRst(tb_nRst), .write_enable(tb_write_enable), .read_enable(tb_read_enable),
.address_DM(tb_address_DM), .address_IM(tb_address_IM), .data_in(tb_data_in), .data_out(tb_data_out),
.instr_out(tb_instr_out), .pc_enable(tb_pc_enable));

initial begin
$dumpfile("dump.vcd");
$dumpvars;

tb_read_enable = 1;
    @(negedge clk);
@(posedge clk);
@(negedge clk);
@(posedge clk);
@(negedge clk);
@(posedge clk);
@(negedge clk);
@(posedge clk);
@(negedge clk);
@(posedge clk);
@(negedge clk);
@(posedge clk);
@(negedge clk);
@(posedge clk);
@(negedge clk);
@(posedge clk);
@(negedge clk);
@(posedge clk);

#1;
$finish;
end
endmodule 
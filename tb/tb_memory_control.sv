`include "src/memory_control.sv"
`timescale 1ms / 100us

module tb_memory_control();
    localparam CLK_PERIOD = 10;

    logic tb_clk, tb_nRST, tb_dmmRen, tb_dmmWen, tb_imemRen, tb_busy_o;
    logic tb_i_ready, tb_d_ready, tb_Ren, tb_Wen;
    logic [31:0] tb_imemaddr, tb_dmmaddr, tb_dmmstore, tb_ramload;
    logic [31:0] tb_ramaddr, tb_ramstore, tb_imemload, tb_dmmload;

     always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end

    memory_control DUT (.CLK(tb_clk), .nRST(tb_nRST), 
                        .dmmRen(tb_dmmRen), .dmmWen(tb_dmmWen), .)

endmodule
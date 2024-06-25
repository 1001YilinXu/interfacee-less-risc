`include "src/request_unit.sv"
`timescale 1ms / 100us

module tb_request_unit();
    localparam CLK_PERIOD = 10;

    logic tb_clk, tb_nRST, tb_i_ready, tb_d_ready, tb_dmmWen, tb_dmmRen, tb_imemRen;
    cuOPType tb_cuOP;
    logic [31:0] tb_dmmstorei, tb_dmmaddri, tb_imemaddri, tb_imemloadi, tb_dmmloadi;
    logic [31:0] tb_dmmstoreo, tb_dmmaddro, tb_imemaddro, tb_imemloado, tb_dmmloado;


    always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end

    request_unit DUT (.CLK(tb_clk), .nRST(tb_nRST), .i_ready(tb_i_ready),
    .d_ready(tb_d_ready), .dmmWen(tb_dmmWen), .dmmRen(tb_dmmRen), .imemRen(tb_imemRen),
    .cuOP(tb_cuOP), 
    .dmmstorei(tb_dmmstorei), .dmmaddri(tb_dmmaddri), .imemaddri(tb_imemaddri), .imemloadi(tb_imemloadi), .dmmloadi(tb_dmmloadi),
    .dmmstoreo(tb_dmmstoreo), .dmmaddro(tb_dmmaddro), .imemaddro(tb_imemaddro), .imemloado(tb_imemloado), .dmmloado(tb_dmmloado));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        tb_nRST = 0; 
        tb_dmmstorei = 0;
        tb_dmmaddri = 0;
        tb_imemaddri = 0;
        tb_cuOP = CU_LH;
        tb_i_ready = 0;
        tb_d_ready = 0; 
        tb_dmmloadi = 0; 
        tb_imemloadi = 0;
       
       #(CLK_PERIOD)
       #(CLK_PERIOD)


        //test i_ready and load word instruction changes dmmRen
    tb_nRST = 1;
    tb_i_ready = 1;
    tb_d_ready = 0;
    tb_cuOP = CU_LB;
    tb_dmmstorei = 32'hABCDABCD;
    tb_dmmaddri = 32'h00010001;
    tb_imemaddri = 32'h12341234;
    #(CLK_PERIOD)
    #(CLK_PERIOD)

    // test d_ready changes dmmRen and dmmWen to 0;
    tb_i_ready = 0;
    tb_d_ready = 1; 
    tb_cuOP = CU_LH;
    #(CLK_PERIOD)
    #(CLK_PERIOD) 

    // test  i_ready and store word instruction
    tb_i_ready = 1;
    tb_d_ready = 0;

    #(CLK_PERIOD)
    tb_cuOp = CU_SW;

    #(CLK_PERIOD)
    #(CLK_PERIOD)

    tb_dmmstorei = 32'hDACBDACB;
    tb_dmmaddri = 32'h01010101;
    tb_imemaddri = 32'h43214321;

    tb_i_ready = 0;
    tb_d_ready = 1;


    end
endmodule
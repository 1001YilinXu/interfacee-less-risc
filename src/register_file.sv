module register_file
(
    input logic clk, nRST, reg_write,
    input logic [4:0] write_index, read_index1, read_index2,
    input logic [31:0] write_data,
    output logic [31:0] read_data1, read_data2
);
logic [31:0] register [31:0];
logic [31:0]nxt_register [31:0]  ;

always_ff@(posedge clk, negedge nRST) begin
    if (!nRST) begin
        for (int i = 0; i<32;  i ++) begin
            register[i] <= 32'b0;
        end
    end
    else if(reg_write) begin
        register <= nxt_register;
    end
end
always_comb begin
    nxt_register [0] = 32'b0;
    if(reg_write & (write_data != 32'b0)) begin
    nxt_register [write_index]= write_data;
    end
end

assign read_data1 = register [read_index1];
assign read_data2 = register [read_index2];
endmodule

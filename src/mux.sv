module mux(
	input logic in1, in2, en,
	output logic out);

	always_comb begin
		if(en) 
			out = in1;
		else
			out = in2;
	end
endmodule
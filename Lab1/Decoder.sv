`timescale 1ns/10ps
module decoder1_2(out, a, enable);
	
	output [1:0] out;
	input logic a, enable;
	
	wire nota;
	
	not #50 (nota, a);
	and #50 (out[0], nota, enable);
	and #50 (out[1], a, enable);
endmodule

module decoder2_4(out, a, enable);
	
	output [3:0] out;
	input logic [1:0] a;
	input logic enable;
	wire[1:0] v;
	
		decoder1_2 d0(.out(v), .a(a[1]), .enable(enable));
		decoder1_2 d1(.out(out[1:0]) , .a(a[0]), .enable(v[0]));
		decoder1_2 d2(.out(out[3:2]), .a(a[0]) ,.enable(v[1]));
	

endmodule

module decoder3_8(out, a, enable);

	output[7:0] out;
	input logic [2:0] a;
	input logic enable; 
	wire [1:0] v;
	
		decoder1_2 d0(.out(v), .a(a[2]), .enable(enable));
		decoder2_4 d1(.out(out[3:0]) , .a(a[1:0]), .enable(v[0]));
		decoder2_4 d2(.out(out[7:4]), .a(a[1:0]) ,.enable(v[1]));
endmodule



module decoder4_16(out, a, enable);

	output[15:0] out;
	input logic [3:0] a;
	input logic enable; 
	wire [1:0] v;
	
		decoder1_2 d0(.out(v), .a(a[3]), .enable(enable));
		decoder3_8 d1(.out(out[7:0]) , .a(a[2:0]), .enable(v[0]));
		decoder3_8 d2(.out(out[15:8]), .a(a[2:0]) ,.enable(v[1]));
endmodule

module decoder5_32(out, a, enable);

	output[31:0] out;
	input logic [4:0] a;
	input logic enable; 
	wire [1:0] v;
	
		decoder1_2 d0(.out(v), .a(a[4]), .enable(enable));
		decoder4_16 d1(.out(out[15:0]) , .a(a[3:0]), .enable(v[0]));
		decoder4_16 d2(.out(out[31:16]), .a(a[3:0]) ,.enable(v[1]));

endmodule



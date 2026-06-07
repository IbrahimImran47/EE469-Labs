`timescale 1ns/1ps
module cpustim();
	logic clk, reset;
	
	cpu dut (.clk(clk), .reset(reset));
	

	parameter ClockDelay = 5000;
	
	initial clk = 0;
	always #(ClockDelay/2) clk = ~clk;
	
	initial begin
		reset = 1;
		@(posedge clk);
		@(posedge clk);
		reset = 0;
		repeat(1000) @(posedge clk);
		$stop;
	end
endmodule

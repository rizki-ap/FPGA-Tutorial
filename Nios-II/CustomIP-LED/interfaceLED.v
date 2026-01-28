module interfaceLED (
	input [1:0] address,
	input chipselect,
	input clk,
	input read,
	input reset_n,
	input write,
	input [31:0] writedata,
	output [9:0] led_out,
	output reg [31:0] readdata
);

	reg [9:0] DATA;
	
	always @ ( posedge clk or negedge reset_n )
	begin
		if ( reset_n == 1'b0 )
		begin
			DATA <= 10'b0;
			readdata <= 32'b0;
		end
		else if ( chipselect && write && (address == 2'b0) )
		begin
			DATA <= writedata[9:0];
			readdata <= 32'b0;
		end
		else if ( chipselect && read && (address == 2'b0) )
		begin
			readdata <= DATA;
			DATA <= DATA;
		end
		else
		begin
			readdata <= 32'b0;
			DATA <= DATA;
		end
	end
	
	assign led_out = DATA;

endmodule 

// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`timescale 1ns / 1ns
`default_nettype none

module vga_desim_arom_160x120 (clk,rst_n,VGA_X,VGA_Y,VGA_RGB,VGA_PLOT);
    // Number of columns and rows in the video memory
    parameter COLS = 160  ;
    parameter ROWS = 120  ;
    parameter nX = 8; // VGA x bitwidth for 640x480
    parameter nY = 7; // VGA y bitwidth for 640x480

    input wire clk;	// DE-series board 50 MHz Clock
    input wire rst_n;		// 

    output reg [nX-1:0] VGA_X;     // VGA column
    output reg [nY-1:0] VGA_Y;     // VGA row
    output reg [23:0] VGA_RGB;   // VGA pixel colour (24-bit color)
    output wire VGA_PLOT;   	// VGA pixel colour (24-bit color)
	
	reg [23:0] color_mem [0:7];
/*	initial begin						//initializing ROM content
		color_mem[0] 	= 24'h000000;
        color_mem[1] 	= 24'h0000FF;
        color_mem[2] 	= 24'h00FF00;
        color_mem[3] 	= 24'h00FFFF;
        color_mem[4] 	= 24'hFF0000;
        color_mem[5] 	= 24'hFF00FF;
        color_mem[6] 	= 24'hFFFF00;
        color_mem[7] 	= 24'hFFFFFF;
    end 
*/
	initial begin
		$readmemh("rom_data.hex", color_mem); //initializing ROM content by file
	end

	assign VGA_PLOT = 1;

    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 0) begin
            VGA_X <= {nX{1'b0}};	// set starting x coordinate
            VGA_Y <= {nY{1'b0}};	// set starting y coordinate
        end
        else begin
		if(VGA_X < 160)	
			VGA_X <= VGA_X + 1'b1;
		else begin			
			VGA_X <= {nX{1'b0}};
			if(VGA_Y < ROWS )
				VGA_Y <= VGA_Y + 1'b1;
			else 
				VGA_Y <= {nY{1'b0}};
		end	
	end
    end
	
	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 0) 
			VGA_RGB <= {24{1'b0}};
		else 
			VGA_RGB <= color_mem[(VGA_Y/15)];
	end
	

endmodule

// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`timescale 1ns / 1ns
`default_nettype none

module vga_desim_160x120 (clk,rst_n,VGA_X,VGA_Y,VGA_RGB,VGA_PLOT);
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
		else begin
			if 	(VGA_X < (COLS>>2)) 		// 10'b00_1010_0000
				VGA_RGB <= 24'hFF0000;	//RED
			else if	(VGA_X < (COLS>>1))		// 10'b01_0100_0000
				VGA_RGB <= 24'h00FF00;	//GREEN
			else if	(VGA_X < (COLS>>1)+(COLS>>2)) 	// 10'b01_1110_0000	
				VGA_RGB <= 24'h0000FF;	//BLUE
			else 						
				VGA_RGB <= 24'hFFFFFF;	//white
		end
	end
endmodule

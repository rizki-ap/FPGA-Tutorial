// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim
// edited by : EDES

`timescale 1ns / 1ns
`default_nettype none

module vga_desim_160x120 (clk,rst_n,VGA_X,VGA_Y,VGA_RGB,VGA_PLOT);
    // Number of columns and rows in the video memory
    parameter COLS = 160  ;	//number of pixel horizontally
    parameter ROWS = 120  ; //number of pixel Vertically
    parameter nX = 8; 		// VGA x bitwidth for 160x120
    parameter nY = 7; 		// VGA y bitwidth for 160x120

    input wire clk;			// DE-series board 50 MHz Clock
    input wire rst_n;		// 

    output reg [nX-1:0] VGA_X;     	// VGA column
    output reg [nY-1:0] VGA_Y;     	// VGA row
    output reg [23:0] VGA_RGB;   	// VGA pixel colour (24-bit color)
    output wire VGA_PLOT;   		// VGA pixel colour (24-bit color)

	assign VGA_PLOT = 1;

    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 0) begin
            VGA_X <= {nX{1'b0}};	// set starting x coordinate
            VGA_Y <= {nY{1'b0}};	// set starting y coordinate
        end
        else begin
			if(VGA_X < 160)				// while x still below max (160)
			VGA_X <= VGA_X + 1'b1;		// keep counting x
		else begin						// if x is already max,
			VGA_X <= {nX{1'b0}};		// reset x to zero
			if(VGA_Y < ROWS )			// and ask if y still below max (120)
				VGA_Y <= VGA_Y + 1'b1;	//if y still below, keep counting y
			else 						
				VGA_Y <= {nY{1'b0}};	//else reset y to zero
		end								//it means 1 full screen already created
	end
    end
	
	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 0) 				// when reset
			VGA_RGB <= {24{1'b0}};		// the default color is 0 (black)
		else begin
			if 	(VGA_X < (COLS>>2)) 	// if x still below 1/4 of max, 
				VGA_RGB <= 24'hFF0000;	// turn it to RED : 0xFF0000
			else if	(VGA_X < (COLS>>1))	// if x between 1/4 and 1/2 of max, 
				VGA_RGB <= 24'h00FF00;	// turn it to GREEN : 0x00FF00
			else if	(VGA_X < (COLS>>1)+(COLS>>2)) 	// if x between 1/2 and 3/4 of max, 
				VGA_RGB <= 24'h0000FF;				// turn it to BLUE : 0x0000ff
			else 						
				VGA_RGB <= 24'hFFFFFF;	//white
		end
	end
endmodule

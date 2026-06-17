// creator : EDES
// desc : controlling box movement simulation for DESim of 160x120 via avalon MM interface

`timescale 1ns / 1ns
`default_nettype none

module vga_desim_box_avalon(clk,rst_n,chipselect,address,write,writedata,read,readdata,VGA_X,VGA_Y,VGA_RGB,VGA_PLOT);

    parameter COLS = 160  ;	//number of pixel horizontally
    parameter ROWS = 120  ; //number of pixel Vertically
    parameter nX = 8; 		// VGA x bitwidth for 160x120
    parameter nY = 7; 		// VGA y bitwidth for 160x120

    input wire clk;					// Avalon Slave-MM clock
	input wire rst_n;				// Avalon Slave-MM reset
	input wire chipselect;			// Avalon Slave-MM chip-select
	input wire [1:0] address;		// Avalon Slave-MM address
    input wire write;				// Avalon Slave-MM write
	input wire read;				// Avalon Slave-MM read
	input wire [16:0] writedata;	// Avalon Slave-MM write-data
	output reg [16:0] readdata;		// Avalon Slave-MM read-data
	output reg [nX-1:0] VGA_X;     	// VGA column
    output reg [nY-1:0] VGA_Y;     	// VGA row
    output reg [23:0] VGA_RGB;   	// VGA pixel colour (24-bit color)
    output wire VGA_PLOT;   		// VGA plot enable
	assign VGA_PLOT = 1'b1;

//the box parameter
	parameter BOX_W		= 10;			// box width
	parameter BOX_H		= 10;			// box height
	parameter BOX_RGB	= 24'h00_FF_00;		// box foreground colors
	parameter BACK_RGB	= 24'hFF_FF_FF;		// background colors
    reg [nX-1:0] box_x;		// box position x (top left corner)
    reg [nY-1:0] box_y;		// box position y (top left corner)

	always @ ( posedge clk or negedge rst_n)begin
		if ( rst_n == 1'b0 ) begin
			readdata <= 16'b0;
			box_x <= 8'd75;
			box_y <= 7'd55;
		end
		else if ( chipselect && read ) begin //reading current VGA X-Y counter or box-x-y 
			if 		(address == 2'b0) 	readdata <= {VGA_X,1'b0,VGA_Y};
			else if (address == 2'b1) 	readdata <= {box_x,1'b0,box_y};
			else 						readdata <= 16'b0;
		end
		else if ( chipselect && write && (address == 2'b1)) begin //moving box X-Y position
			box_x <= writedata[15:8];
			box_y <= writedata[6:0];
		end
		else
		begin
			readdata <= 16'b0;
			box_x <= box_x;
			box_y <= box_y;
		end
	end
	
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
	
	always @(posedge clk or negedge rst_n) begin	//drawing the box and background
		if (rst_n == 0) 
			VGA_RGB <= {24{1'b0}};
		else begin
			if 	((VGA_X>box_x)&&(VGA_Y>box_y)&&(VGA_X<(box_x+BOX_W))&&(VGA_Y<(box_y+BOX_H)))
				VGA_RGB <= BOX_RGB ;	//if the the x-y now is the box coordinate draw box color
			else
				VGA_RGB <= BACK_RGB;	//if other draw background color
		end
	end
	
endmodule

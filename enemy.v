module enemy
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	reg [2:0] colour;
	reg [7:0] x;
	reg [6:0] y;
	reg writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK),
			.VGA_SYNC(VGA_SYNC),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";

	
    wire loadX,loadY,load_colour,en_counter,load_black,en_delay_counter,reset_delay;
	 wire [3:0] cnt;
	 wire [3:0] delay_cnt;
	 wire en_reset;
	 wire [2:0] colour1;
	wire [7:0] x1;
	wire [6:0] y1;
	wire writeEn1; 
	
	 wire loadX2,loadY2,load_colour2,en_counter2,load_black2,en_delay_counter2,reset_delay2;
	 wire [3:0] cnt2;
	 wire [3:0] delay_cnt2;
	 wire en_reset2;
	wire [2:0] colour2;
	wire [7:0] x2;
	wire [6:0] y2;
	wire writeEn2; 
	//reg start_c1,			start_c2,			start_d1,		start_d2;

wire cho;
	reg choice;	
    always @(posedge CLOCK_50)
		begin
		if (cho==0)
			begin
				choice =~cho;
				x=x1;
				y=y1;
				colour=colour1;
				writeEn=writeEn1;
			end
		else if (cho==1)
			begin
				choice =~cho;
				x=x2;
				y=y2;
				colour=colour2;
				writeEn=writeEn2;
			end
		end
		assign cho=choice;
	

	enemy_controller Control_path(choice,0,CLOCK_50,resetn,x1,y1,cnt,delay_cnt,loadX,loadY,load_colour,load_black,writeEn1
	,en_counter,en_delay_counter,reset_delay,en_reset);
	

	enemy_datapath Data_path(choice,0,CLOCK_50,~en_reset,cnt,delay_cnt,loadX,loadY,load_colour,load_black,reset_delay,
	en_counter,en_delay_counter,x1,y1,colour1);
   
	enemy_controller Control_path1(choice,1,CLOCK_50,resetn,x2,y2,cnt2,delay_cnt2,loadX2,loadY2,load_colour2,load_black2,writeEn2
	,en_counter2,en_delay_counter2,reset_delay2,en_reset2);

	enemy_datapath Data_path1(choice,1,CLOCK_50,~en_reset2,cnt2,delay_cnt2,loadX2,loadY2,load_colour2,load_black2,reset_delay2,
	en_counter2,en_delay_counter2,x2,y2,colour2);

	assign count=choice;
endmodule

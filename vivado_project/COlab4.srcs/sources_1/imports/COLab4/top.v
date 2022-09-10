`define CYCLE_TIME 20
`timescale 1ns / 1ps
`include "CPU.v"

module top(
    SW,
	rst,
	clk,
	CA,
	CB,
	CC,
	CD,
	CE,
	CF,
	CG,
	AN0,
	AN1,
	AN2,
	AN3,
	AN4,
	AN5,
	AN6,
	AN7
    );
    
	input [12:0]SW; 
    input rst;
	input clk;
	
	output CA,CB,CC,CD,CE,CF,CG;
	output AN0,AN1,AN2,AN3,AN4,AN5,AN6,AN7;
	
	reg [7:0] scan;
	reg [3:0] seg_number;
	reg [6:0] seg_data;
	reg [20:0] counter;
	reg [2:0] state;
	reg [31:0] cnt_2hz;
	reg clk_2hz;
	reg [31:0] cycles, i;
	wire [31:0] inpt;

    assign inpt = {19'b0,SW[12:0]};
	assign {AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0} = scan;
	assign cpu.MEM.tmp_inpt = inpt;
	
	// Instruction DM initialilation
	initial
	begin
			
			/*MAIN*/
			cpu.IF.instruction[  0] = 32'b100011_00001_00001_00000_00000_000000;	//lw
			cpu.IF.instruction[  1] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[  2] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[  3] = 32'b000000_00000_00000_00000_00000_100000;	//5

			cpu.IF.instruction[  4] = 32'b000000_00000_01011_00100_00000_100000;	//add




			cpu.IF.instruction[  5] = 32'b000000_00001_00000_00011_00000_100000;	//add
			cpu.IF.instruction[  6] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[  7] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[  8] = 32'b000000_00000_00000_00000_00000_100000;	//10

			/*Remain main*/
			cpu.IF.instruction[  9] = 32'b000000_00011_01011_00011_00000_100010;	//sub
			cpu.IF.instruction[ 10] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 11] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 12] = 32'b000000_00000_00000_00000_00000_100000;	//14

			cpu.IF.instruction[ 13] = 32'b000000_00011_00100_00010_00000_101010;	//slt
			cpu.IF.instruction[ 14] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 15] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 16] = 32'b000000_00000_00000_00000_00000_100000;	//18

			cpu.IF.instruction[ 17] = 32'b000100_00010_00000_11111_11111_110111;	//beq
			cpu.IF.instruction[ 18] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 19] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 20] = 32'b000000_00000_00000_00000_00000_100000;	//22

			cpu.IF.instruction[ 21] = 32'b000100_00011_00000_00000_00000_000111;	//beq
			cpu.IF.instruction[ 22] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 23] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 24] = 32'b000000_00000_00000_00000_00000_100000;	//26

			cpu.IF.instruction[ 25] = 32'b000010_00000_00000_00000_00000_100110;	//j
			cpu.IF.instruction[ 26] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 27] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 28] = 32'b000000_00000_00000_00000_00000_100000;	//30

			/*input_is_even*/
			cpu.IF.instruction[ 29] = 32'b000000_00001_01010_00010_00000_100010;	//sub




			cpu.IF.instruction[ 30] = 32'b000000_00001_01010_00011_00000_100000;	//add
			cpu.IF.instruction[ 31] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 32] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 33] = 32'b000000_00000_00000_00000_00000_100000;	//35

			cpu.IF.instruction[ 34] = 32'b000010_00000_00000_00000_00000_101011;	//j
			cpu.IF.instruction[ 35] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 36] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 37] = 32'b000000_00000_00000_00000_00000_100000;	//39
			
			/*else*/
			cpu.IF.instruction[ 38] = 32'b000000_00001_00000_00010_00000_100000;	//add




			cpu.IF.instruction[ 39] = 32'b000000_00001_00000_00011_00000_100000;	//add
			cpu.IF.instruction[ 40] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 41] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 42] = 32'b000000_00000_00000_00000_00000_100000;	//44

			/*larger*/
			cpu.IF.instruction[ 43] = 32'b000000_00010_01011_00010_00000_100000;	//add




			cpu.IF.instruction[ 44] = 32'b000000_00000_01010_00100_00000_100000;	//add
			cpu.IF.instruction[ 45] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 46] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 47] = 32'b000000_00000_00000_00000_00000_100000;	//49
			
			/*factor_larger*/
			cpu.IF.instruction[ 48] = 32'b000000_00100_01011_00100_00000_100000;	//add
			cpu.IF.instruction[ 49] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 50] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 51] = 32'b000000_00000_00000_00000_00000_100000;	//53

			cpu.IF.instruction[ 52] = 32'b000100_00100_00010_00000_00000_011011;	//beq
			cpu.IF.instruction[ 53] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 54] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 55] = 32'b000000_00000_00000_00000_00000_100000;	//57

			cpu.IF.instruction[ 56] = 32'b000000_00010_00100_00101_00000_100010;	//sub
			cpu.IF.instruction[ 57] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 58] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 59] = 32'b000000_00000_00000_00000_00000_100000;	//61
			
			/*remain_larger*/
			cpu.IF.instruction[ 60] = 32'b000100_00101_00100_11111_11111_101110;	//beq
			cpu.IF.instruction[ 61] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 62] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 63] = 32'b000000_00000_00000_00000_00000_100000;	//65

			cpu.IF.instruction[ 64] = 32'b000000_00101_00100_01000_00000_101010;	//slt
			cpu.IF.instruction[ 65] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 66] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 67] = 32'b000000_00000_00000_00000_00000_100000;	//69

			cpu.IF.instruction[ 68] = 32'b000101_01000_00000_11111_11111_101011;	//bne
			cpu.IF.instruction[ 69] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 70] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 71] = 32'b000000_00000_00000_00000_00000_100000;	//73

			cpu.IF.instruction[ 72] = 32'b000000_00101_00100_00101_00000_100010;	//sub
			cpu.IF.instruction[ 73] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 74] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 75] = 32'b000000_00000_00000_00000_00000_100000;	//77

			cpu.IF.instruction[ 76] = 32'b000010_00000_00000_00000_00000_111100;	//j
			cpu.IF.instruction[ 77] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 78] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 79] = 32'b000000_00000_00000_00000_00000_100000;	//81
			
			/*smaller*/
			cpu.IF.instruction[ 80] = 32'b000000_00011_01011_00011_00000_100010;	//sub
			cpu.IF.instruction[ 81] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 82] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 83] = 32'b000000_00000_00000_00000_00000_100000;	//85

			cpu.IF.instruction[ 84] = 32'b000000_00000_01010_00110_00000_100000;	//add
			cpu.IF.instruction[ 85] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 86] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 87] = 32'b000000_00000_00000_00000_00000_100000;	//89
			
			/*factor_smaller*/
			cpu.IF.instruction[ 88] = 32'b000000_00110_01011_00110_00000_100000;	//add
			cpu.IF.instruction[ 89] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 90] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 91] = 32'b000000_00000_00000_00000_00000_100000;	//93

			cpu.IF.instruction[ 92] = 32'b000100_00110_00011_00000_00000_011011;	//beq
			cpu.IF.instruction[ 93] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 94] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 95] = 32'b000000_00000_00000_00000_00000_100000;	//97

			cpu.IF.instruction[ 96] = 32'b000000_00011_00110_00111_00000_100010;	//sub
			cpu.IF.instruction[ 97] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 98] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[ 99] = 32'b000000_00000_00000_00000_00000_100000;	//101
			
			/*remain_smaller*/
			cpu.IF.instruction[100] = 32'b000100_00111_00110_11111_11111_101011;	//beq
			cpu.IF.instruction[101] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[102] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[103] = 32'b000000_00000_00000_00000_00000_100000;	//105

			cpu.IF.instruction[104] = 32'b000000_00111_00110_01001_00000_101010;	//slt
			cpu.IF.instruction[105] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[106] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[107] = 32'b000000_00000_00000_00000_00000_100000;	//109

			cpu.IF.instruction[108] = 32'b000101_01001_00000_11111_11111_101011;	//bne
			cpu.IF.instruction[109] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[110] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[111] = 32'b000000_00000_00000_00000_00000_100000;	//113

			cpu.IF.instruction[112] = 32'b000000_00111_00110_00111_00000_100010;	//sub
			cpu.IF.instruction[113] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[114] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[115] = 32'b000000_00000_00000_00000_00000_100000;	//117

			cpu.IF.instruction[116] = 32'b000010_00000_00000_00000_00001_100100;	//j
			cpu.IF.instruction[117] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[118] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[119] = 32'b000000_00000_00000_00000_00000_100000;	//121
			
			/*show_ans*/
			cpu.IF.instruction[120] = 32'b101011_00000_00010_00000_00000_000001;	//sw
			cpu.IF.instruction[121] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[122] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[123] = 32'b000000_00000_00000_00000_00000_100000;	//125

			cpu.IF.instruction[124] = 32'b101011_00000_00011_00000_00000_000010;	//sw
			cpu.IF.instruction[125] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[126] = 32'b000000_00000_00000_00000_00000_100000;
			cpu.IF.instruction[127] = 32'b000000_00000_00000_00000_00000_100000;	//129


			cpu.IF.PC = 0;
		
		
		
	end

	
	//**CLK_DIV**//
    always@ (posedge clk or posedge rst) begin
        if (rst) begin
            cnt_2hz <= 32'b0;
            clk_2hz <= 1'b0;
        end
        else begin
            if (cnt_2hz >= 25000000) begin
                cnt_2hz <= 32'b0;
                clk_2hz <= ~clk_2hz;
            end
            else begin
                cnt_2hz <= cnt_2hz + 1;
                clk_2hz <= clk_2hz;
            end
        end
    end
	
	//clock cycle time is 20ns, inverse Clk value per 10ns
	//initial clk = 1'b1;
	//always #(`CYCLE_TIME/2) clk = ~clk;

	//Rst signal
	//initial begin
	//	cycles = 32'b0;
	//	rst = 1'b1;
	//	#12 rst = 1'b0;
	//end

	CPU cpu(
		.clk(clk),
		.rst(rst)
	);
	
	wire [15:0] resultA, resultB;
	
	assign resultA = cpu.MEM.DM[1];
	assign resultB = cpu.MEM.DM[2];
    
    always @( posedge clk ) begin
		
		counter <=(counter<=100000) ? (counter +1) : 0;
		state <= (counter==100000) ? (state + 1) : state;
		
		case(state)
		
			0: begin
				seg_number <= resultA / 1000;
				scan <= 8'b0111_1111;
			end
			
			1: begin
				seg_number <= (resultA / 100) % 10;
				scan <= 8'b1011_1111;
			end
			
			2: begin
				seg_number <= (resultA / 10) % 10;
				scan <= 8'b1101_1111;
			end
			
			3: begin
				seg_number <= resultA % 10;
				scan <= 8'b1110_1111;
			end
			
			4: begin
				seg_number <= resultB / 1000;
				scan <= 8'b1111_0111;
			end
			
			5: begin
				seg_number <= (resultB / 100) % 10;
				scan <= 8'b1111_1011;
			end
			
			6: begin
				seg_number <= (resultB / 10) % 10;
				scan <= 8'b1111_1101;
			end
			
			7: begin
				seg_number <= resultB % 10;
				scan <= 8'b1111_1110;
			end
			
			default: state <= state;
		endcase
    end
	
	assign {CG,CF,CE,CD,CC,CB,CA} = seg_data;
	
	always@(posedge clk) begin  
	  case(seg_number)
		  4'd0:seg_data <= 7'b100_0000;
		  4'd1:seg_data <= 7'b111_1001;
		  4'd2:seg_data <= 7'b010_0100;
		  4'd3:seg_data <= 7'b011_0000;
		  4'd4:seg_data <= 7'b001_1001;
		  4'd5:seg_data <= 7'b001_0010;
		  4'd6:seg_data <= 7'b000_0010;
		  4'd7:seg_data <= 7'b101_1000;
		  4'd8:seg_data <= 7'b000_0000;
		  4'd9:seg_data <= 7'b001_0000;
		default: seg_data <= seg_data;
	  endcase
	end 
	
	
endmodule

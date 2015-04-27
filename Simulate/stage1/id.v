`include "defs.v"

module id(
	input wire rst,
	input wire[`InstAddrBus] pc_i,
	input wire[`InstBus] inst_i,

	input wire[`RegBus] reg1_data_i,
	input wire[`RegBus] reg2_data_i,

	output reg reg1_read_o,
	output reg reg2_read_o,
	output reg[`RegAddrBus] reg1_addr_o,
	output reg[`RegAddrBus] reg2_addr_o,

	output reg[`AluOpBus] aluop_o,
	output reg[`AluSelBus] alusel_o,
	output reg[`RegBus] reg1_o,
	output reg[`RegBus] reg2_o,
	output reg[`RegAddrBus] wd_o,
	output reg wreg_o);


	wire[5:0] op = inst_i[31:26];	//op
	wire[4:0] op2 = inst_i[10:6];	//sa, only use in << or >> instrction
	wire[5:0] op3 = inst_i[5:0];	//func, decide ins combined with op in R ins
	wire[4:0] op4 = inst_i[20:16];	//source reg

	reg[`RegBus] imm;
	reg instvalid;



/**************** Step 1: Instrction Decode ****************/
	always @(*) begin
		if (rst == `RstEnable) begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
			instvalid <= `InstValid;
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= `NOPRegAddr;
			reg2_addr_o <= `NOPRegAddr;
			imm <= 32'h00;
		end else begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= inst_i[15:11];  		//Destination reg
			wreg_o <= `WriteDisable;
			instvalid <= `InstInvalid; 		//be valid after Decode successful
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= inst_i[25:21];
			reg2_addr_o <= inst_i[20:16];
			imm <= `ZeroWord;				// No immediate num in R ins

			case (op)
				`EXE_ORI : begin
					wreg_o <= `WriteEnable;
					aluop_o <= `EXE_OR_OP;
					alusel_o <= `EXE_RES_LOGIC;
					reg1_read_o <= 1'b1;
					reg2_read_o <= 1'b0;
					//immediate num expand to 32bits
					imm <= {16'h0000, inst_i[15:0]};
					wd_o <= inst_i[20:16];
					instvalid <= `InstValid;
				end


				default: begin
				end
			endcase
		end
	end

/********************** Step 2: decide operate num 1 ***************/
	always @(*) begin
		if (rst == `RstEnable) begin
			reg1_o <= `ZeroWord;
		end else if (reg1_read_o == 1'b1) begin
			reg1_o <= reg1_data_i;
		end else if (reg1_read_o == 1'b0) begin
			reg1_o <= imm;
		end else begin
			reg1_o <= `ZeroWord;
		end
	end
/********************* Step 3: decide operate num 2 *****************/
	always @(*) begin
		if (rst == `RstEnable) begin
			reg2_o <= `ZeroWord;
		end else if (reg2_read_o == 1'b1) begin
			reg2_o <= reg2_data_i;
		end else if (reg2_read_o == 1'b0) begin
			reg2_o <= imm;
		end else begin
			reg2_o <= `ZeroWord;
		end
	end


endmodule
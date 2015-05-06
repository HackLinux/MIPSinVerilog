`include "defs.v"

module ex(
 	input wire rst,
 	input wire[`AluOpBus] aluop_i,
 	input wire[`AluSelBus] alusel_i,
 	input wire[`RegBus] reg1_i,
 	input wire[`RegBus] reg2_i,
 	input wire[`RegAddrBus] wd_i,
 	input wire wreg_i,

 	input wire[`RegBus] hi_i,
 	input wire[`RegBus] lo_i,

 	input wire[`RegBus] wb_hi_i,
 	input wire[`RegBus] wb_lo_i,
 	input wire	wb_whilo_i,

 	input wire[`RegBus] mem_hi_i,
 	input wire[`RegBus] mem_lo_i,
 	input wire 	mem_whilo_i,


 	input wire[`DoubleRegBus] hilo_temp_i,
 	input wire[1:0] cnt_i,
 	output reg[`DoubleRegBus] hilo_temp_o,
 	output reg[1:0] cnt_o,


 	output reg pausereq_ex,

 	output reg[`RegBus] hi_o,
 	output reg[`RegBus] lo_o,
 	output reg whilo_o,

 	output reg[`RegAddrBus] wd_o,
 	output reg  wreg_o,
 	output reg[`RegBus] wdata_o
 	);






 	reg[`RegBus] logicout;
	reg[`RegBus] shiftout;
	reg[`RegBus] moveout;
	reg[`RegBus] HI;
	reg[`RegBus] LO;

	wire ov_sum;
	wire reg1_eq_reg2;
	wire reg1_lt_reg2;
	reg[`RegBus] mathout;
	wire[`RegBus] reg2_i_mux;
	wire[`RegBus] reg1_i_not;
	wire[`RegBus] result_sum;
	wire[`RegBus] opdata1_mult;
	wire[`RegBus] opdata2_mult;
	wire[`DoubleRegBus] hilo_temp;
	reg[`DoubleRegBus] mulres;
	reg[`DoubleRegBus] hilo_temp1;
	reg pausereq_madd_msub;

	// always @(*) begin
	// 	pausereq_ex <= `NoStop;
	// end

	assign reg2_i_mux = ((aluop_i == `EXE_SUB_OP) || 
							(aluop_i == `EXE_SUBU_OP) || 
							(aluop_i == `EXE_SLT_OP)) ? (~reg2_i + 1) : reg2_i;

	assign result_sum = reg1_i + reg2_i_mux;

	assign ov_sum = ((!reg1_i[31] && !reg2_i_mux[31]) && (result_sum[31])) || 
					((reg1_i[31] && reg2_i_mux[31]) && (!result_sum[31]));

	assign reg1_lt_reg2 = (aluop_i == `EXE_SLT_OP) ?
							((reg1_i[31] && !reg2_i[31]) || 
								(!reg1_i[31] && !reg2_i[31] && result_sum[31]) || 
								(reg1_i[31] && reg2_i[31] && result_sum[31]))
							: (reg1_i < reg2_i);

	assign reg1_i_not = ~reg1_i;

	//mathout + -
	always @(*) begin
		if (rst == `RstEnable) begin
			mathout <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_SLT_OP, `EXE_SLTU_OP : begin
					mathout <= reg1_lt_reg2;
				end

				`EXE_ADD_OP, `EXE_ADDU_OP, `EXE_ADDI_OP, `EXE_ADDIU_OP ,
				`EXE_SUB_OP, `EXE_SUBU_OP : begin
					mathout <= result_sum;
				end

				`EXE_CLZ_OP : begin
					mathout <= (reg1_i[31] ? 0 :
					reg1_i[30] ? 1 :
					reg1_i[29] ? 2 :
					reg1_i[28] ? 3 :
					reg1_i[27] ? 4 :
					reg1_i[26] ? 5 :
					reg1_i[25] ? 6 :
					reg1_i[24] ? 7 :
					reg1_i[23] ? 8 :
					reg1_i[22] ? 9 :
					reg1_i[21] ? 10 :
					reg1_i[20] ? 11 :
					reg1_i[19] ? 12 :
					reg1_i[18] ? 13 :
					reg1_i[17] ? 14 :
					reg1_i[16] ? 15 :
					reg1_i[15] ? 16 :
					reg1_i[14] ? 17 :
					reg1_i[13] ? 18 :
					reg1_i[12] ? 19 :
					reg1_i[11] ? 20 :
					reg1_i[10] ? 21 :
					reg1_i[9] ? 22 :
					reg1_i[8] ? 23 :
					reg1_i[7] ? 24 :
					reg1_i[6] ? 25 :
					reg1_i[5] ? 26 :
					reg1_i[4] ? 27 :
					reg1_i[3] ? 28 :
					reg1_i[2] ? 29 :
					reg1_i[1] ? 30 :
					reg1_i[0] ? 31 : 32);
				end

				`EXE_CLO_OP : begin
					mathout <= (reg1_i_not[31] ? 0 :
					reg1_i_not[30] ? 1 :
					reg1_i_not[29] ? 2 :
					reg1_i_not[28] ? 3 :
					reg1_i_not[27] ? 4 :
					reg1_i_not[26] ? 5 :
					reg1_i_not[25] ? 6 :
					reg1_i_not[24] ? 7 :
					reg1_i_not[23] ? 8 :
					reg1_i_not[22] ? 9 :
					reg1_i_not[21] ? 10 :
					reg1_i_not[20] ? 11 :
					reg1_i_not[19] ? 12 :
					reg1_i_not[18] ? 13 :
					reg1_i_not[17] ? 14 :
					reg1_i_not[16] ? 15 :
					reg1_i_not[15] ? 16 :
					reg1_i_not[14] ? 17 :
					reg1_i_not[13] ? 18 :
					reg1_i_not[12] ? 19 :
					reg1_i_not[11] ? 20 :
					reg1_i_not[10] ? 21 :
					reg1_i_not[9] ? 22 :
					reg1_i_not[8] ? 23 :
					reg1_i_not[7] ? 24 :
					reg1_i_not[6] ? 25 :
					reg1_i_not[5] ? 26 :
					reg1_i_not[4] ? 27 :
					reg1_i_not[3] ? 28 :
					reg1_i_not[2] ? 29 :
					reg1_i_not[1] ? 30 :
					reg1_i_not[0] ? 31 : 32);
				end

				default : begin
					mathout <= `ZeroWord;
				end

			endcase
		end
	end

	// mathout x
	assign opdata1_mult = (((aluop_i == `EXE_MUL_OP) || (aluop_i == `EXE_MULT_OP) || (aluop_i == `EXE_MADD_OP) || (aluop_i == `EXE_MSUB_OP))
							&& (reg1_i[31] == 1'b1)) ? (~reg1_i + 1) : reg1_i;
	assign opdata2_mult = (((aluop_i == `EXE_MUL_OP) || (aluop_i == `EXE_MULT_OP) || (aluop_i == `EXE_MADD_OP) || (aluop_i == `EXE_MSUB_OP))
							&& (reg2_i[31] == 1'b1)) ? (~reg2_i + 1) : reg2_i;

	assign hilo_temp = opdata1_mult * opdata2_mult;

  	always @(*) begin
		if (rst == `RstEnable) begin
			mulres <= {`ZeroWord, `ZeroWord};
		end else if((aluop_i == `EXE_MULT_OP) || (aluop_i == `EXE_MUL_OP) || (aluop_i == `EXE_MADD_OP) || (aluop_i == `EXE_MSUB_OP)) begin
			if (reg1_i[31] ^ reg2_i[31] == 1'b1) begin
				mulres <= ~hilo_temp + 1;
			end else begin
				mulres <= hilo_temp;
			end
		end else begin
			mulres <= hilo_temp;
		end
	end																



	//MADD MADDU MSUB MSUBU
	always @(*) begin
		if (rst == `RstEnable) begin
			hilo_temp_o <= {`ZeroWord, `ZeroWord};
			cnt_o <= 2'b00;
			hilo_temp1 <= {`ZeroWord, `ZeroWord};
			pausereq_madd_msub <= `NoStop;
		end else begin
			case (aluop_i)
				`EXE_MADD_OP, `EXE_MADDU_OP : begin
					if (cnt_i == 2'b00) begin
						hilo_temp_o <= mulres;
						cnt_o <= 2'b01;
						hilo_temp1 <= {`ZeroWord, `ZeroWord};
						pausereq_madd_msub <= `Stop;
					end else if (cnt_i == 2'b01) begin
						hilo_temp_o <= {`ZeroWord, `ZeroWord};
						cnt_o <= 2'b10;
						hilo_temp1 <= hilo_temp_i + {HI, LO};
						pausereq_madd_msub <= `NoStop;
					end
				end

				`EXE_MSUB_OP, `EXE_MSUBU_OP : begin
					if (cnt_i == 2'b00) begin
						hilo_temp_o <= ~mulres + 1;
						cnt_o <= 2'b01;
						pausereq_madd_msub <= `Stop;
					end else if (cnt_i == 2'b01) begin
						hilo_temp_o <= {`ZeroWord, `ZeroWord};
						cnt_o <= 2'b10;
						hilo_temp1 <= hilo_temp_i + {HI, LO};
						pausereq_madd_msub <= `NoStop;
					end
				end

				default : begin
					hilo_temp_o <= {`ZeroWord, `ZeroWord};
					cnt_o <= 2'b00;
					pausereq_madd_msub <= `NoStop;
				end
			endcase
		end
	end

	always @(pausereq_madd_msub) begin
		if (rst == `RstEnable) begin
			pausereq_ex <= `NoStop;
		end else begin
			pausereq_ex <= pausereq_madd_msub;
		end
	end

	//Logic Result
 	always @(*) begin
 		if (rst == `RstEnable) begin
 			logicout <= `ZeroWord;
 		end else begin
 			case(aluop_i)
 				`EXE_OR_OP : begin
 					logicout <= reg1_i | reg2_i;
 				end

				`EXE_AND_OP : begin
					logicout <= reg1_i & reg2_i;
				end

				`EXE_NOR_OP : begin
					logicout <= ~(reg1_i | reg2_i);
				end

				`EXE_XOR_OP : begin
					logicout <= reg1_i ^ reg2_i;
				end

 				default : begin
 					logicout <= `ZeroWord;
 				end
 			endcase
 		end
 	end


	//Shift Result
	always @(*) begin
		if (rst == `RstEnable) begin
			shiftout <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_SLL_OP : begin
					shiftout <= reg2_i << reg1_i[4:0];
				end

				`EXE_SRL_OP : begin
					shiftout <= reg2_i >> reg1_i[4:0];
				end

				`EXE_SRA_OP : begin
					shiftout <= ({32{reg2_i[31]}} << (6'd32 - {1'b0, reg1_i[4:0]})) | reg2_i >> reg1_i[4:0];
				end

				default : begin
					shiftout <= `ZeroWord;
				end
			endcase
		end
	end



	//get new HI LO
	always @(*) begin
		if (rst == `RstEnable) begin
			{HI, LO} = {`ZeroWord, `ZeroWord};
		end else if (mem_whilo_i == `WriteEnable) begin
			{HI, LO} = {mem_hi_i, mem_lo_i};
		end else if (wb_whilo_i == `WriteEnable) begin
			{HI, LO} = {wb_hi_i, wb_lo_i};
		end else begin
			{HI, LO} = {hi_i, lo_i};
		end
	end



	//MFHI, MFLO, MOVN, MOVZ
	always @(*) begin
		// moveout <= `ZeroWord
		if (rst == `RstEnable) begin
			moveout <= `ZeroWord;
		end else begin
			moveout <= `ZeroWord;
			case (aluop_i)
				`EXE_MFHI_OP : begin
					moveout <= HI;
				end

				`EXE_MFLO_OP : begin
					moveout <= LO;
				end

				`EXE_MOVZ_OP : begin
					moveout <= reg1_i;
				end

				`EXE_MOVN_OP : begin
					moveout <= reg1_i;
				end

				default : begin
				end
			endcase
		end
	end



	always @(*) begin
		if (rst == `RstEnable) begin
			whilo_o <= `WriteDisable;
			{hi_o, lo_o} <= {`ZeroWord, `ZeroWord};
		end else if ((aluop_i == `EXE_MSUB_OP) || (aluop_i == `EXE_MSUBU_OP)) begin
			whilo_o <= `WriteEnable;
			{hi_o, lo_o} <= hilo_temp1;
		end else if ((aluop_i == `EXE_MADD_OP) || (aluop_i == `EXE_MADDU_OP)) begin
			whilo_o <= `WriteEnable;
			{hi_o, lo_o} <= hilo_temp1;
		end else if ((aluop_i == `EXE_MULTU_OP) || (aluop_i == `EXE_MULT_OP)) begin
			whilo_o <= `WriteEnable;
			hi_o <= mulres[63:32];
			lo_o <= mulres[31:0];
		end else if (aluop_i == `EXE_MTHI_OP) begin
			whilo_o <= `WriteEnable;
			{hi_o, lo_o} = {reg1_i, LO};
		end else if (aluop_i == `EXE_MTLO_OP) begin
			whilo_o <= `WriteEnable;
			{hi_o, lo_o} = {HI, reg1_i};
		end else begin
			whilo_o <= `WriteDisable;
			{hi_o, lo_o} <= {`ZeroWord, `ZeroWord};
		end
	end



	//Select output
 	always @(*) begin
 		wd_o <= wd_i;

 		if (((aluop_i == `EXE_ADD_OP) || (aluop_i == `EXE_ADDI_OP) || (aluop_i == `EXE_SUB_OP))
 			 && (ov_sum == 1'b1)) begin
 			//overflow exception
 			wreg_o <= `WriteDisable;
 		end else begin
 			wreg_o <= wreg_i;
 		end

 		case(alusel_i)
 			`EXE_RES_LOGIC : begin
 				wdata_o <= logicout;
 			end

			`EXE_RES_SHIFT : begin
				wdata_o <= shiftout;
			end

			`EXE_RES_MOVE : begin
				wdata_o <= moveout;
			end

			`EXE_RES_MATH : begin
				wdata_o <= mathout;
			end

			`EXE_RES_MUL : begin
				wdata_o <= mulres[31:0];
			end

 			default : begin
 				wdata_o <= `ZeroWord;
 			end
 		endcase
 	end


 endmodule

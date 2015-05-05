`include "defs.v"

module ex_mem(
	input wire rst,
	input wire clk,

	input wire[`RegAddrBus] ex_wd,
	input wire[`RegBus] ex_wdata,
	input wire ex_wreg,

	input wire[`RegBus] ex_hi,
	input wire[`RegBus] ex_lo,
	input wire ex_whilo,

	input wire[5:0] pause,
	input wire[`DoubleRegBus] hilo_i,
	input wire[1:0] cnt_i,
	output reg[`DoubleRegBus] hilo_o,
	output reg[1:0] cnt_o,

	output reg[`RegBus] mem_hi,
	output reg[`RegBus] mem_lo,
	output reg mem_whilo,

	output reg[`RegAddrBus] mem_wd,
	output reg[`RegBus] mem_wdata,
	output reg mem_wreg);

	always @(posedge clk) begin
		if (rst == `RstEnable) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
			mem_wdata <= `ZeroWord;
			{mem_hi, mem_lo} <= {`ZeroWord, `ZeroWord};
			mem_whilo <= `WriteDisable;
			hilo_o <= {`ZeroWord, `ZeroWord};
			cnt_o <= 2'b00;
		end else if (pause[3] == `Stop && pause[4] == `NoStop) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
			mem_wdata <= `ZeroWord;
			{mem_hi, mem_lo} <= {`ZeroWord, `ZeroWord};
			mem_whilo <= `WriteDisable;
			hilo_o <= hilo_i;
			cnt_o <= cnt_i;
		end else if (pause[3] == `NoStop) begin
			mem_wd <= ex_wd;
			mem_wreg <= ex_wreg;
			mem_wdata <= ex_wdata;
			{mem_hi, mem_lo} <= {ex_hi, ex_lo};
			mem_whilo <= ex_whilo;
			hilo_o <= {`ZeroWord, `ZeroWord};
			cnt_o <= 2'b00;
		end else begin
			hilo_o <= hilo_i;
			cnt_o <= cnt_i;
		end
	end

endmodule
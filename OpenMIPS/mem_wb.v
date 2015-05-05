`include "defs.v"

module mem_wb(
	input wire rst,
	input wire clk,

	input wire[`RegAddrBus] mem_wd,
	input wire[`RegBus] mem_wdata,
	input wire mem_wreg,

	input wire[`RegBus] mem_hi,
	input wire[`RegBus] mem_lo,
	input wire mem_whilo,

	input wire[5:0] pause,

	output reg[`RegBus] wb_hi,
	output reg[`RegBus] wb_lo,
	output reg wb_whilo,

	output reg[`RegAddrBus] wb_wd,
	output reg[`RegBus] wb_wdata,
	output reg wb_wreg);

	always @( posedge clk) begin
		if (rst == `RstEnable) begin
			wb_wd <= `NOPRegAddr;
			wb_wreg <= `WriteDisable;
			wb_wdata <= `ZeroWord;
			{wb_hi, wb_lo} <= {`ZeroWord, `ZeroWord};
			wb_whilo <= `WriteDisable;
		end else if (pause[4] == `Stop && pause[5] == `NoStop) begin
			wb_wd <= `NOPRegAddr;
			wb_wreg <= `WriteDisable;
			wb_wdata <= `ZeroWord;
			{wb_hi, wb_lo} <= {`ZeroWord, `ZeroWord};
			wb_whilo <= `WriteDisable;
		end else if (pause[4] == `NoStop) begin
			wb_wd <= mem_wd;
			wb_wreg <= mem_wreg;
			wb_wdata <= mem_wdata;
			{wb_hi, wb_lo} <= {mem_hi, mem_lo};
			wb_whilo <= mem_whilo;
		end
	end

endmodule
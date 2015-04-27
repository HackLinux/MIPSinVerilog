`include "defs.v"

module ex_mem(
	input wire rst,
	input wire clk,

	input wire[`RegAddrBus] ex_wd,
	input wire[`RegBus] ex_wdata,
	input wire ex_wreg,

	output reg[`RegAddrBus] mem_wd,
	output reg[`RegBus] mem_wdata,
	output reg mem_wreg);

	always @(posedge clk) begin
		if (rst == `RstEnable) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
			mem_wdata <= `ZeroWord;
		end else begin
			mem_wd <= ex_wd;
			mem_wreg <= ex_wreg;
			mem_wdata <= ex_wdata;
		end
	end

endmodule
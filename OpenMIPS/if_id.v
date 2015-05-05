`include "defs.v"

module if_id(
	input wire clk,
	input wire rst,
	input wire[`InstAddrBus] if_pc,
	input wire[`InstBus] if_inst,
	input wire[5:0] pause,

	output reg[`InstAddrBus] id_pc,
	output reg[`InstBus] id_inst);

	always @(posedge clk) begin
		if (rst == `RstEnable) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		//should it be     			if(pause[1] == `NoStop) begin balabala end else begin `ZeroWord end    ?
		end else if (pause[1] == `Stop && pause[2] == `NoStop) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		end else if(pause[1] == `NoStop) begin
			id_pc <= if_pc;
			id_inst <= if_inst;
		end
	end
endmodule
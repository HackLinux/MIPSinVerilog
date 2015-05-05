`include "defs.v"

module ctrl(
	input wire rst,
	input wire pausereq_id,
	input wire pausereq_ex,

	output reg[5:0] pause);

	always @(*) begin
		if (rst == `RstEnable) begin
			pause <= 6'b000000;
		end else if (pausereq_ex == `Stop) begin
			pause <= 6'b001111;
		end else if (pausereq_id == `Stop) begin
			pause <= 6'b000111;
		end else begin
			pause <= 6'b000000;
		end
	end

endmodule
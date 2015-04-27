module inst_fetch(
	input wire clk,
	input wire rst,

	output wire[31:0] inst_0);

	wire[5:0] pc;
	wire rom_ce;

	pc_reg pc_reg0(.clk(clk), .rst(rst), .pc(pc), .ce(rom_ce));

	rom rom0(.ce(rom_ce), .addr(pc), .inst(inst_0));

endmodule
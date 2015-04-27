`include "defs.v"
`timescale 1ns/1ps

module openmips_min_sopc_tb();

  reg     CLOCK_50;
  reg     rst;
  
  //50MHz
  initial begin
    CLOCK_50 = 1'b0;
    forever #100 CLOCK_50 = ~CLOCK_50;
  end
      
  initial begin
    rst = `RstDisable;
    //#15 rst= `RstDisable;
    #1000 $stop;
  end
       
  openmips_min_sopc openmips_min_sopc0(
		.clk(CLOCK_50),
		.rst(rst)	
	);

endmodule
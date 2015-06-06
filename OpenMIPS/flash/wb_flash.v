
module flash_top(
    //Wishbone
    input wire wb_clk_i,
	 input wire wb_rst_i, 
	 input wire[31:0] wb_adr_i,
	 output reg[31:0] wb_dat_o,
	 input wire[31:0] wb_dat_i,
	 input wire[3:0] wb_sel_i,
	 input wire wb_we_i,
    input wire wb_stb_i,
	 output wire wb_cyc_i,
	 output reg wb_ack_o,
    //flash
    output reg[31:0] flash_adr_o,
	 input wire[7:0] flash_dat_i,
	 output wire flash_rst,
    output wire flash_oe,
	 output wire flash_ce,
	 output wire flash_we,
	 
	 output wire flash_byte_cfg
);

    // Default address and data bus width
    //parameter aw = 19;   // number of address-bits
    //parameter dw = 32;   // number of data-bits
    //parameter ws = 5'h5; // number of wait-states

    // FLASH interface


    reg [4:0] waitstate;
    //wire    [1:0] adr_low;	 

    // Wishbone read/write accesses
    wire wb_acc = wb_cyc_i & wb_stb_i;    // WISHBONE access
    //wire wb_wr  = wb_acc & wb_we_i;       // WISHBONE write access
    wire wb_rd  = wb_acc & !wb_we_i;      // WISHBONE read access
	 
	 assign flash_byte_cfg = 1'b0;
    assign flash_ce = !wb_acc;
    assign flash_we = 1'b1;
    assign flash_oe = !wb_rd;
    assign flash_rst = !wb_rst_i;
	 

    always @(posedge wb_clk_i) begin
        if( wb_rst_i == 1'b1 ) begin
            waitstate <= 5'h0;
            wb_ack_o <= 1'b0;
        end else if(wb_acc == 1'b0) begin
            waitstate <= 5'h0;
            wb_ack_o <= 1'b0;
            wb_dat_o <= 32'h00000000;
        end else if(waitstate == 5'h0) begin
            wb_ack_o <= 1'b0;
            if(wb_acc) begin
                waitstate <= waitstate + 5'h1;
            end
            flash_adr_o <= {10'b0000000000,wb_adr_i[21:2],2'b00};
        end else begin
            waitstate <= waitstate + 5'h1;
				
				if(waitstate == 5'h5) begin
					wb_dat_o[31:24] <= flash_dat_i;
					flash_adr_o <= {10'b0000000000,wb_adr_i[21:2],2'b01};
				end else if(waitstate == 5'ha) begin
					wb_dat_o[23:16] <= flash_dat_i;
					flash_adr_o <= {10'b0000000000,wb_adr_i[21:2],2'b10};
				end else if(waitstate == 5'hf) begin
					wb_dat_o[15:8] <= flash_dat_i;
					flash_adr_o <= {10'b0000000000,wb_adr_i[21:2],2'b11};
				end else if(waitstate == 5'h14) begin
					wb_dat_o[7:0] <= flash_dat_i;
					wb_ack_o <= 1'b1;
				end else if(waitstate == 5'h15) begin
					wb_ack_o <= 1'b0;
					waitstate <= 5'h0;
            end
        end
    end



endmodule

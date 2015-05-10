`include "defines.v"

module openmips_min_sopc(

	input wire			clk,
	input wire			rst,

	input wire			uart_rx,
	input wire 			uart_tx,

	input wire[15:0]	gpio_i,
	output wire[31:0]	gpio_o,

	input wire[7:0]		flash_data_i,
	output wire[21:0]	flash_addr_o,
	output wire			flash_we_o,
	output wire			flash_rst_o,
	output wire			flash_oe_o,
	output wire			flash_ce_o,

	output wire			sdr_clk_o,
	output wire			sdr_cs_n_o,
	output wire 		sdr_cke_o,
	output wire			sdr_ras_n_o,
	output wire 		sdr_cas_n_o,
	output wire 		sdr_we_n_o,
	output wire[1:0]	sdr_dqm_o,
	output wire[1:0]	sdr_ba_o,
	output wire[12:0]	sdr_addr_o,
	inout wire[15:0]	sdr_dq_io
	
);


	wire[7:0] 			intr;
	wire				timer_intr;
	wire				gpio_intr;
	wire				uart_intr;
	wire[31:0]			gpio_i_temp;


	wire[31:0]			m0_data_i;
	wire[31:0]			m0_data_o;
	wire[31:0]			m0_addr_i;
	wire[3:0]			m0_sel_i;
	wire				m0_we_i;
	wire				m0_cyc_i;
	wire				m0_stb_i;
	wire				m0_ack_o;


	wire[31:0]			m1_data_i;
	wire[31:0]			m1_data_o;
	wire[31:0]			m1_addr_i;
	wire[3:0]			m1_sel_i;
	wire				m1_we_i;
	wire				m1_cyc_i;
	wire				m1_stb_i;
	wire				m1_ack_o;


	wire[31:0]			s0_data_i;
	wire[31:0]			s0_data_o;
	wire[31:0]			s0_addr_o;
	wire[3:0]			s0_sel_o;
	wire				s0_we_o;
	wire				s0_cyc_o;
	wire				s0_stb_o;
	wire				s0_ack_i;


	wire[31:0]			s1_data_i;
	wire[31:0]			s1_data_o;
	wire[31:0]			s1_addr_o;
	wire[3:0]			s1_sel_o;
	wire				s1_we_o;
	wire				s1_cyc_o;
	wire				s1_stb_o;
	wire				s1_ack_i;


	wire[31:0]			s2_data_i;
	wire[31:0]			s2_data_o;
	wire[31:0]			s2_addr_o;
	wire[3:0]			s2_sel_o;
	wire				s2_we_o;
	wire				s2_cyc_o;
	wire				s2_stb_o;
	wire				s2_ack_i;


	wire[31:0]			s3_data_i;
	wire[31:0]			s3_data_o;
	wire[31:0]			s3_addr_o;
	wire[3:0]			s3_sel_o;
	wire				s3_we_o;
	wire				s3_cyc_o;
	wire				s3_stb_o;
	wire				s3_ack_i;


	wire sdram_init_done;

	assign sdr_clk_o = clk;



	openmips openmips0(
		.clk(clk), 							.rst(rst),
		.int(intr),							.timer_int_o(timer_intr),

		.iwishbone_data_i(m1_data_o), 		.iwishbone_ack_i(m1_ack_o),
		.iwishbone_addr_o(m1_addr_i),		.iwishbone_data_o(m1_data_i),
		.iwishbone_we_o(m1_we_i),			.iwishbone_sel_o(m1_sel_i),
		.iwishbone_stb_o(m1_stb_i),			.iwishbone_cyc_o(m1_cyc_i),

		.dwishbone_data_i(m0_data_o),		.dwishbone_ack_i(m0_ack_o),
		.dwishbone_addr_o(m0_addr_i),		.dwishbone_data_o(m0_data_i),
		.dwishbone_we_o(m0_we_i),			.dwishbone_sel_o(m0_sel_i),
		.dwishbone_stb_o(m0_stb_i),			.dwishbone_cyc_o(m0_cyc_i),
		);

	assign intr = {3'b000, gpio_intr, uart_intr, timer_intr};





	gpio_top gpio_top0(
		wb_clk_i(clk),						wb_rst_i(rst),
		wb_cyc_i(s2_cyc_o),					wb_adr_i(s2_addr_o[7:0]),
		wb_dat_i(s2_data_o),				wb_sel_i(s2_sel_o),
		wb_we_i(s2_we_o),					wb_stb_i(s2_stb_o),
		wb_dat_o(s2_data_i),				wb_ack_o(s2_ack_i),
		wb_err_o(),							wb_inta_o(gpio_intr),
		ext_pad_i(gpio_i_temp),				ext_pad_o(gpio_o),
		ext_padoe_o()
		);

	assign gpio_i_temp = {15'h0000, sdram_init_done, gpio_i};






	flash_top flash_top0(
		wb_clk_i(clk),						wb_rst_i(rst),
		wb_adr_i(s3_addr_o),				wb_dat_o(s3_data_i),
		wb_dat_i(s3_data_o),				wb_sel_i(s3_sel_o),
		wb_we_i(s3_we_o),					wb_stb_i(s3_stb_o),
		wb_cyc_i(s3_cyc_o),					wb_ack_o(s3_ack_i),

		flash_adr_o(flash_addr_o),			flash_dat_i(flash_data_i),
		flash_rst(flash_rst_o),				flash_oe(flash_oe_o),
		flash_ce(flash_ce_o),				flash_we(flash_we_o)
		);





	uart_top uart_top0(
		wb_clk_i(clk),						wb_rst_i(rst),
		wb_adr_i(s1_addr_o[4:0]),			wb_dat_i(s1_data_o),
		wb_dat_o(s1_data_i),				wb_we_i(s1_we_o),
		wb_stb_i(s1_stb_o),					wb_cyc_i(s1_cyc_o),
		wb_ack_o(s1_ack_i),					wb_sel_i(s1_sel_o),

		int_o(uart_intr),

		stx_pad_o(uart_tx),					srx_pad_i(uart_rx),

		rts_pad_o(),						cts_pad_i(1'b0),
		dtr_pad_o(),						dsr_pad_i(1'b0),
		ri_pad_i(1'b0),						dcd_pad_i(1'b0)
		);






	sdrc_top sdrc_top0(
		wb_rst_i(rst),						wb_clk_i(clk),
		wb_stb_i(s0_stb_o),					wb_ack_o(s0_ack_i),
		wb_addr_i({s0_addr_o[25:2], 2'b00}),
		wb_we_i(s0_we_o),					wb_dat_i(s0_data_o),
		wb_sel_i(s0_sel_o),					wb_dat_o(s0_data_i),
		wb_cyc_i(s0_cyc_o),					wb_cti_i(3'b000),


		sdram_clk(clk),						sdram_resetn(~rst),
		sdr_cs_n(sdr_cs_n_o),				sdr_cke(sdr_cke_o),
		sdr_ras_n(sdr_ras_n_o),				sdr_cas_n(sdr_cas_n_o),
		sdr_we_n(sdr_we_n_o),				sdr_dqm(sdr_dqm_o),
		sdr_ba(sdr_ba_o),					sdr_addr(sdr_addr_o),
		sdr_dq(sdr_dq_io),

		sdr_init_done(sdram_init_done),


		cfg_sdr_width(2'b01),//16bit(),01
		cfg_colbits(2'b00),//sdramcolumnbit(),8bit(),00
		cfg_req_depth(2'b11),	//howmanyreq.buffershouldhold
		cfg_sdr_en(1'b1),//sdramenable
		cfg_sdr_mode_reg(13'b0000000110001),//sdrammoderegister(),0x21
		cfg_sdr_tras_d(4'b1000),//activetoprecharge(),Tras(),inclocks
		cfg_sdr_trp_d(4'b0010),//prechargecommandperiod(),Trp(),inclocks
		cfg_sdr_trcd_d(4'b0010),//activetoread/writedelay(),Trcd(),inclocks
		cfg_sdr_cas(3'b100),//CASlatency(),inclocks
		cfg_sdr_trcar_d(4'b1010),//activetoactive/auto-refreshcommandperiod(),Trcar(),inclocks
		cfg_sdr_twr_d(4'b0010),//writerecoverytimes(),Twr(),inclocks
		cfg_sdr_rfsh(12'b101110000000),//periodsbetweenauto-refreshcommands(),inclocks
		cfg_sdr_rfmax(3'b100)
	);








	
	wb_conmax_top wb_conmax_top0(
		clk_i(clk),						rst_i(rst),

		// Master 0 Interface
		m0_data_i(m0_data_i), 			m0_data_o(m0_data_o), 
		m0_addr_i(m0_addr_i), 			m0_sel_i(m0_sel_i), 
		m0_we_i(m0_we_i), 				m0_cyc_i(m0_cyc_i),
		m0_stb_i(m0_stb_i), 			m0_ack_o(m0_ack_o), 
		m0_err_o(), 					m0_rty_o(),

		// Master 1 Interface
		m1_data_i(m1_data_i), 			m1_data_o(m1_data_o), 
		m1_addr_i(m1_addr_i), 			m1_sel_i(m1_sel_i), 
		m1_we_i(m1_we_i), 				m1_cyc_i(m1_cyc_i),
		m1_stb_i(m1_stb_i), 			m1_ack_o(m1_ack_o), 
		m1_err_o(), 					m1_rty_o(),


		m2_data_i(`ZeroWord), 			m2_data_o(), 
		m2_addr_i(`ZeroWord), 			m2_sel_i(4'b0000), 
		m2_we_i(1'b0), 					m2_cyc_i(1'b0),
		m2_stb_i(1'b0), 				m2_ack_o(), 
		m2_err_o(), 					m2_rty_o(),


		m3_data_i(`ZeroWord), 			m3_data_o(), 
		m3_addr_i(`ZeroWord), 			m3_sel_i(4'b0000), 
		m3_we_i(1'b0), 					m3_cyc_i(1'b0),
		m3_stb_i(1'b0), 				m3_ack_o(), 
		m3_err_o(), 					m3_rty_o(),


	s1_data_i(), s1_data_o(), s1_addr_o(), s1_sel_o(), s1_we_o(), s1_cyc_o(),
	s1_stb_o(), s1_ack_i(), s1_err_i(), s1_rty_i(),



		s10_data_i(), s10_data_o(), s10_addr_o(), s10_sel_o(), s10_we_o(), s10_cyc_o(),
	s10_stb_o(), s10_ack_i(), s10_err_i(), s10_rty_i(),






)


endmodule
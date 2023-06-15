`include "defines.v"

/*
    基于OpenMIPS处理器的一个简单SOPC，用于验证具备了
    wishbone总线接口的openmips，该SOPC包含openmips、
    wb_conmax、GPIO controller、flash controller，uart 
    controller，以及用来仿真flash的模块flashmem，在其中
    存储指令，用来仿真外部ram的模块datamem，在其中存储
    数据，并且具有wishbone总线接口 

*/
module openmips_min_sopc (
    input wire clk,
    input wire rst
);
    // 连接指令存储器
    wire[`InstAddrBus] inst_addr;
    wire[`InstBus] inst;
    wire rom_ce;

    openmips openmips0(
        .clk(clk),
		.rst(rst),
	
		.rom_addr_o(inst_addr),
		.rom_data_i(inst),
		.rom_ce_o(rom_ce)
    );

    inst_rom inst_rom0(
		.addr(inst_addr),
		.inst(inst),
		.ce(rom_ce)	
	);
    
endmodule
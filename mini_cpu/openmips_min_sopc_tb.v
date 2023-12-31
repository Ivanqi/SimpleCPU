// `include "defines.v"
`timescale 1ns/1ns

module openmips_min_sopc_tb ();

    reg     CLOCK_50;
    reg     rst;

    // 每隔10ns，CLOCK_50信号翻转1次，所以一个周期是20ns，对应50MHz
    initial begin
        CLOCK_50 = 1'b0;
        forever #10 CLOCK_50 = ~CLOCK_50;
    end

    // 最初时刻，复位信号有效，在195ns，复位信号无效，最小SOPC开始运行
    // 运行10000ns后，暂停仿真
    initial begin
        rst = `RstEnable;
        #195 rst= `RstDisable;
        #1000 $stop;
    end

    // 例化最小SOPC
    openmips_min_sopc openmips_min_sopc0(
		.clk(CLOCK_50),
		.rst(rst)	
	);
    
endmodule
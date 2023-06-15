// `include "defines.v"

// 指令存储器ROM模块是只读的
module inst_rom (
    input wire ce,                  // 使能信号
    input wire[`InstAddrBus] addr,  // 要读取的指令地址
    output reg[`InstBus] inst       // 读出的指令
);
    // 定义一个数组，大小是InstMemNum，元素宽度是InstBus
    reg[`InstBus] inst_mem[0:`InstMemNum-1];

    // 使用文件inst_rom.data初始化指令存储器
    // inst_rom.data 是一个文本文件，里面存储的是指令，其每行存储一条32位宽度指令(16进制)
    // 系统函数$readmemh会将inst_rom.data中的依次填写到inst_mem数组中
    initial $readmemh ("inst_rom.data", inst_mem);

    // 当复位信号无效时，依据输入的地址，给出指令存储器ROM中对应的元素
    always @ (*) begin
		if (ce == `ChipDisable) begin
			inst <= `ZeroWord;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
		end
	end
    
endmodule
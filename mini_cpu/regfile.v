// `include "defines.v"

// Regfile 模块实现了32个32位通用整数寄存器
module regfile (
    input wire clk,                     // 时钟信号
    input wire rst,                     // 复位信号

    // 写端口
    input wire we,                      // 写使能信号
    input wire[`RegAddrBus] waddr,      // 要写入的寄存器地址
    input wire[`RegBus] wdata,          // 要写入的数据

    // 读端口
    input wire re1,                     // 第一个读寄存器端口读使能信号
    input wire[`RegAddrBus] raddr1,     // 第一个读寄存器端口要读取的寄存器的地址
    output reg[`RegBus] rdata1,         // 第一个读寄存器端口输出的寄存器值

    //读端口2
	input wire	re2,                    // 第二个读寄存器端口读使能信号
	input wire[`RegAddrBus]	raddr2,     // 第二个读寄存器端口要读取的寄存器的地址
	output reg[`RegBus]  rdata2         // 第二个读寄存器端口输出的寄存器值
);
    // 第一阶段: 定义32个32位寄存器(二维向量)
    reg[`RegBus] regs[0:`RegNum-1];

    // 读寄存器操作是组合逻辑电路，也就是一旦输入的要读取的寄存器raddr1和raddr2发生变化，那么会立即给出新地址对应的寄存器的值
    // 这样可以保证在译码阶段取得要读取的寄存器的值
    // 而写寄存器操作是时序逻辑电路，写操作发生在时钟信号上升沿

    // 第二阶段: 写操作
    // 当复位信号无效时候(rst == `RstDisable），在写使能信号we有效(we == `WriteEnable),且写操作目的寄存器不等于0的情况下
    // 可以将写输入数据保存到目的寄存器
    // 之所以要判断目的寄存器不为0，是因为MIPS32架构规定$0的值只能位0，所以不要写入
    always @(posedge clk) begin
        if (rst == `RstDisable) begin
            if ((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin
                regs[waddr] <= wdata;
            end
        end
    end

    // 第三阶段: 读端口1的读操作
    // 当复位信号有效时，第一个读寄存器端口的输出始终位0
    // 当复位信号无效时, 如果读取的是$0, 那么直接给出0
    // 如果第一个读寄存器端口要读取的目标寄存器与要写入的目的寄存器是同一个寄存器，那么直接将要写入的值作为第一个读寄存器端口的输出
    // 如果上述情况都不满足，那么给出第一个读寄存器端口要读取的目标寄存器地址对应寄存器的值
    // 第一个读寄存器端口不能使用时，直接输出0
    always @(*) begin
        if (rst == `RstEnable) begin
            rdata1 <= `ZeroWord;
        end else if (raddr1 == `RegNumLog2'h0) begin
            rdata1 <= `ZeroWord;
        end else if ((raddr1 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable)) begin
            rdata1 <= wdata;
        end else if (re1 == `ReadEnable) begin
            rdata1 <= regs[raddr1];
        end else begin
            rdata1 <= `ZeroWord;
        end
    end

    // 第四阶段: 读端口2的读操作
    always @(*) begin
        if (rst == `RstEnable) begin
            rdata2 <= `ZeroWord;
        end else if (raddr2 == `RegNumLog2'h0) begin
            rdata2 <= `ZeroWord;
        end else if ((raddr2 == waddr) && (we == `WriteEnable) && (re2 == `ReadEnable)) begin
            rdata2 <= wdata;
        end else if (re2 == `ReadEnable) begin
            rdata2 <= regs[raddr2];
        end else begin
            rdata2 <= `ZeroWord;
        end
    end
    
endmodule
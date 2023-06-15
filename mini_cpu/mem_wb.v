// `include "defines.v"

// MEM/WB 模块将访存阶段指令是否要写目的寄存器mem_wreg、要写的目的寄存器地址mem_wd、要写入的数据mem_wdata的信息
// 传递到回写阶段对应的接口wb_wreg,wb_wd,wb_wdata
module mem_wb (
    input wire clk,                     // 时钟信号
    input wire rst,                     // 复位信号

    // 来自访存阶段的信息
    input wire[`RegAddrBus] mem_wd,     // 访存阶段的指令最终要写入的目的寄存器地址
    input wire mem_wreg,                // 访存阶段的指令最终是否有要写入的目的寄存器
    input wire[`RegBus] mem_wdata,      // 访存阶段的指令最终要写入目的寄存器的值

    // 送到回写阶段的信息
    output reg[`RegAddrBus] wb_wd,      // 回写阶段的指令要写入的目的寄存器地址
    output reg wb_wreg,                 // 回写阶段的指令是否有要写入的目的寄存器
    output reg[`RegBus] wb_wdata        // 回写阶段的指令要写入目的寄存器的值
);  

    // 时序逻辑电路
    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            wb_wd <= `NOPRegAddr;
            wb_wreg <= `WriteDisable;
            wb_wdata <= `ZeroWord;
        end else begin
            wb_wd <= mem_wd;
            wb_wreg <= mem_wdata;
            wb_wdata <= mem_wdata;
        end
    end
    
endmodule
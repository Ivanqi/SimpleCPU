// `include "defines.v"

module mem (
    input wire rst,                 // 复位信号

    // 来自执行阶段的信息
    input wire[`RegAddrBus] wd_i,   // 访存阶段的指令要写入的目的寄存器地址
    input wire wreg_i,              // 访存阶段的指令是否有要写入的目的寄存器
    input wire[`RegBus] wdata_i,    // 访存阶段的指令要写入目的寄存器的值

    // 送到回写阶段的信息
    output reg[`RegAddrBus] wd_o,   // 访存阶段的指令最终要写入的目的寄存器地址
    output reg wreg_o,              // 访存阶段的指令最终是否有要写入的目的寄存器
    output reg[`RegBus] wdata_o     // 访存阶段的指令最终要写入目的寄存器的值
);

    // 组合逻辑电路。将输入的执行阶段的结果直接作为输出
    always @(*) begin
        if (rst == `RstEnable) begin
            wd_o <= `NOPRegAddr;
            wreg_o <= `WriteDisable;
            wdata_o <= `ZeroWord;
        end else begin
            wd_o <= wd_i;
            wreg_o <= wreg_i;
        end
    end
    
endmodule
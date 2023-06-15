// `include "defines.v"

// 将译码阶段取得的运算类型、源操作数、要写的目的寄存器地址等结果，在下一个时钟传递到流水线执行阶段
module id_ex (
    input wire clk,                     // 时钟信号
    input wire rst,                     // 复位信号

    // 从译码阶段传递的信息
    input wire[`AluOpBus] id_aluop,     // 译码阶段的指令要进行的运算的子类型
    input wire[`AluSelBus] id_alusel,   // 译码阶段的指令要进行的运算的类型
    input wire[`RegBus] id_reg1,        // 译码阶段的指令要进行的运算的源操作数1
    input wire[`RegBus] id_reg2,        // 译码阶段的指令要进行的运算的源操作数2
    input wire[`RegAddrBus] id_wd,      // 译码阶段的指令要写入的目的寄存器地址
    input wire id_wreg,                 // 译码阶段的指令是否有要写入的目的寄存器

    // 传递到执行阶段的信息
    output reg[`AluOpBus] ex_aluop,     // 执行阶段的指令要进行的运算的子类型
    output reg[`AluSelBus] ex_alusel,   // 执行阶段的指令要进行的运算的类型
    output reg[`RegBus] ex_reg1,        // 执行阶段的指令要进行的运算的源操作数1
    output reg[`RegBus] ex_reg2,        // 执行阶段的指令要进行的运算的源操作数2
    output reg[`RegAddrBus] ex_wd,      // 执行阶段的指令要写入的目的寄存器地址
    output reg ex_wreg                  // 执行阶段的指令是否有要写入的目的寄存器
);

    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            ex_aluop <= `EXE_NOP_OP;
            ex_alusel <= `EXE_RES_NOP;
            ex_reg1 <= `ZeroWord;
            ex_reg2 <= `ZeroWord;
            ex_wd <= `NOPRegAddr;
            ex_wreg <= `WriteDisable;
        end else begin
            ex_aluop <= id_aluop;
            ex_alusel <= id_alusel;
            ex_reg1 <= id_reg1;
            ex_reg2 <= id_reg2;
            ex_wd <= id_wd;
            ex_wreg <= id_wreg;
        end
    end
    
endmodule
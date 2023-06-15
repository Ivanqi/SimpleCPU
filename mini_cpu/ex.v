// `include "defines.v"

// EX模块会从ID/EX模块中得到运算类型alusel_i、运算子类型aluop_i、源操作数reg1_i、源操作数reg2_i、要写的目的寄存器地址wd_i
module ex (
    input wire rst,                     // 复位信号

    // 译码阶段送到执行阶段的信息
    input wire[`AluOpBus] aluop_i,      // 执行阶段要进行的运算的子类型
    input wire[`AluSelBus] alusel_i,    // 执行阶段要进行的运算的类型
    input wire[`RegBus] reg1_i,         // 参与运算的源操作数1
    input wire[`RegBus] reg2_i,         // 参与运算的源操作数2
    input wire[`RegAddrBus] wd_i,       // 指令执行要写入的目的寄存器地址
    input wire wreg_i,                  // 是否有要写入的目的寄存器

    // 执行的结果
    output reg[`RegAddrBus] wd_o,       // 执行阶段的指令最终要写入的目的寄存器地址
    output reg wreg_o,                  // 执行阶段的指令最终是否有要写入目的寄存器
    output reg[`RegBus] wdata_o         // 执行阶段的指令最终要写入目的寄存器的值
);
    // 保存逻辑运算的结果
    reg[`RegBus] logicout;

    // 第一阶段: 依据aluop_i指示的运算子类型进行运算，此处只有逻辑"或"运算
    always @(*) begin
        if (rst == `RstEnable) begin
            logicout <= `ZeroWord;
        end else begin
            case (aluop_i)
                `EXE_OR_OP: begin
                    logicout <= reg1_i | reg2_i;
                end
                default: begin
                    logicout <= `ZeroWord;
                end
            endcase
        end // if
    end // always

    // 第二阶段: 依据alusel_i 指示的运算类型，选择一个运算结果作为最终结果
    always @(*) begin
        wd_o <= wd_i;       // wd_o 等于wd_i，要写的目的寄存器地址
        wreg_o <= wreg_i;   // wreg_o等于wreg_i,表示是否要写目的寄存器
        case (alusel_i)
            `EXE_RES_LOGIC: begin
                wdata_o <= logicout;    // wdata_o中存放运算结果
            end
            default:begin
                wdata_o <= `ZeroWord;
            end
        endcase

    end
    
endmodule
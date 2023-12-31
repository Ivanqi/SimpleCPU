// 访存控制模块
//  1. 访存控制信号中，最重要的两个信号就是存储器读控制信号 memRead 和写控制信号 memWrite
//  2. 当然，访存的控制信号通路也会受流水线冲刷等流水线管理信号的控制
module ex_mem_ctrl(
    input        clk,
    input        reset,
    input        in_mem_ctrl_memRead,   //memory读控制信号
    input        in_mem_ctrl_memWrite,  //memory写控制信号
    input  [1:0] in_mem_ctrl_maskMode,  //mask模式选择
    input        in_mem_ctrl_sext,      //符合扩展
    input        in_wb_ctrl_toReg,      //写回寄存器的数据选择，“1”时为mem读取的数据
    input        in_wb_ctrl_regWrite,   //寄存器写控制信号
    input        flush,                 //流水线数据冲刷信号

    output       out_mem_ctrl_memRead,
    output       out_mem_ctrl_memWrite,
    output [1:0] out_mem_ctrl_maskMode,
    output       out_mem_ctrl_sext,
    output       out_wb_ctrl_toReg,
    output       out_wb_ctrl_regWrite
);

    reg  reg_mem_ctrl_memRead; 
    reg  reg_mem_ctrl_memWrite; 
    reg [1:0] reg_mem_ctrl_maskMode; 
    reg  reg_mem_ctrl_sext; 
    reg  reg_wb_ctrl_toReg; 
    reg  reg_wb_ctrl_regWrite; 

    assign out_mem_ctrl_memRead = reg_mem_ctrl_memRead; 
    assign out_mem_ctrl_memWrite = reg_mem_ctrl_memWrite; 
    assign out_mem_ctrl_maskMode = reg_mem_ctrl_maskMode; 
    assign out_mem_ctrl_sext = reg_mem_ctrl_sext; 
    assign out_wb_ctrl_toReg = reg_wb_ctrl_toReg; 
    assign out_wb_ctrl_regWrite = reg_wb_ctrl_regWrite; 

    // 要根据流水线的冲刷控制信号 flush，判断访存阶段的控制信号是否需要清零
    // 如果 flush 等于“0”，就把上一阶段送过来的控制信号（比如存储器读控制信号 memRead、存储器写控制信号 memWrite……等）
    // 通过寄存器保存下来，然后发送给存储器读写控制模块（dmem_rw.v）或者流水线的下一级使用
    always @(posedge clk or posedge reset) begin
        if (reset) begin 
            reg_mem_ctrl_memRead <= 1'h0; 
        end else if (flush) begin 
            reg_mem_ctrl_memRead <= 1'h0; 
        end else begin 
            reg_mem_ctrl_memRead <= in_mem_ctrl_memRead; 
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin 
            reg_mem_ctrl_memWrite <= 1'h0; 
        end else if (flush) begin 
            reg_mem_ctrl_memWrite <= 1'h0; 
        end else begin 
            reg_mem_ctrl_memWrite <= in_mem_ctrl_memWrite; 
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin 
            reg_mem_ctrl_maskMode <= 2'h0; 
        end else if (flush) begin 
            reg_mem_ctrl_maskMode <= 2'h0; 
        end else begin 
            reg_mem_ctrl_maskMode <= in_mem_ctrl_maskMode; 
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin 
            reg_mem_ctrl_sext <= 1'h0; 
        end else if (flush) begin 
            reg_mem_ctrl_sext <= 1'h0; 
        end else begin 
            reg_mem_ctrl_sext <= in_mem_ctrl_sext; 
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin 
            reg_wb_ctrl_toReg <= 1'h0; 
        end else if (flush) begin 
            reg_wb_ctrl_toReg <= 1'h0; 
        end else begin 
            reg_wb_ctrl_toReg <= in_wb_ctrl_toReg; 
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin 
            reg_wb_ctrl_regWrite <= 1'h0; 
        end else if (flush) begin 
            reg_wb_ctrl_regWrite <= 1'h0; 
        end else begin 
            reg_wb_ctrl_regWrite <= in_wb_ctrl_regWrite; 
        end
    end
endmodule
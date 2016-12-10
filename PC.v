module PC
(
    clk_i,
    start_i,
    PCWrite_i,
    pc_i,
    pc_o
);

// Ports
input               clk_i;
input               start_i;
input               PCWrite_i;
input   [31:0]      pc_i;
output  [31:0]      pc_o;

// Wires & Registers
reg     [31:0]      pc_o;


/* 

    TODO : modify PC
    notice : 1. add PCWrite_i
             2. no rst_i
*/

always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        pc_o <= 32'b0;
    end
    else begin
        if(start_i)
            pc_o <= pc_i;
        else
            pc_o <= pc_o;
    end
end

endmodule

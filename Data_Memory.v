module Data_Memory
(
	clk_i,
	Address_i,
	Writedata_i,
	MemWrite_i,
	MemRead_i,
	Readdata_o
);

input			clk_i;
input	[31:0]	Address_i;
input	[31:0]	Writedata_i;
input			MemWrite_i;
input			MemRead_i;
output	[31:0]	Readdata_o;

reg 	[31:0]	memory 		[0:255];
reg     [31:0]  Readdata_o;

always@(*) begin
	if (MemRead_i) begin
		Readdata_o = memory[Address_i];
	end
	if (MemWrite_i) begin
		memory[Address_i] = Writedata_i;
	end
end


endmodule
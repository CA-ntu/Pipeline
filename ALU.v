module ALU(
	data1,
	data2,
	ALUCtr,
	dataout
);

input[31:0] data1;
input[31:0] data2;
input[2:0] ALUCtr;
output[31:0] dataout;

reg[31:0] do;

always@(*)
begin
  if(ALUCtr == 3'b000)
  	do = data1 + data2;
  else if(ALUCtr == 3'b001)
    do = data1 - data2;
  else if(ALUCtr == 3'b010)
    do = data1 | data2;
  else if(ALUCtr == 3'b011)
    do = data1 & data2;
  else if(ALUCtr == 3'b100)
    do = data1 * data2;
end

assign dataout = do;

endmodule




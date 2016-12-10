module MUX7(
  data1,
  data2,
  data3,
  signal,
  dataout,
);

input[31:0] data1;
input[31:0] data2;
input [31:0] data3;
input[1:0] signal;
output[31:0] dataout;

reg[31:0] data_o;

always@(*)
begin
  if(signal == 2'b10)
    data_o =  data1;
  else if(signal == 2'b01)
    data_o = data2;
  else
    data_o = data3;
end

assign dataout = data_o;

endmodule


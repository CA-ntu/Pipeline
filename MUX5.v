module MUX5(
  data1,
  data2,
  signal,
  dataout,
);

input[31:0] data1;
input[31:0] data2;
input signal;
output[31:0] dataout;

reg[31:0] data_o;

always@(*)
begin
  if(signal)
    data_o =  data1;
  else
    data_o = data2;
end

assign dataout = data_o;

endmodule



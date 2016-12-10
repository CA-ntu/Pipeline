module MUX3(
  data1,
  data2,
  signal,
  dataout
);

input[4:0] data1;
input[4:0] data2;
input signal;
output [4:0] dataout;

reg[4:0] do;

always@(*)
begin
  if(signal)
    do = data1;
  else
    do = data2;
end

assign dataout = do;

endmodule

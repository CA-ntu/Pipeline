module MUX8(
  data1,
  data2,
  signal,
  dataout
  );
  
  
input[7:0] data1;
input[7:0] data2;
input signal;
output[7:0] dataout;

reg[7:0] do;

always@(*)
begin
  if(signal)
    do = data1;
  else
    do = data2;
end

assign dataout = do;

endmodule 
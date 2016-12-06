module Sign_Extend(data_i, data_o);
  input[15:0] data_i;
  output[31:0] data_o;
  assign data_o[15:0] = data_i;
  assign data_o[31:16] = 16'b0;

endmodule 

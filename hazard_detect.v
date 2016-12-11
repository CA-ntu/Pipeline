module hazard_detect(
  ID_EX_MEM_Read,
  ID_EX_RegRt,
  IF_ID_RegRs,
  IF_ID_RegRt,
  PC_Write,
  IF_ID_Write,
  NOP);

input ID_EX_MEM_Read;
input[4:0] ID_EX_RegRt;
input[4:0] IF_ID_RegRs;
input[4:0] IF_ID_RegRt;
output PC_Write;
output IF_ID_Write;
output NOP;

reg pc;
reg ifid;
reg nop;

always@(*)
begin
  if(ID_EX_MEM_Read &&
     ID_EX_RegRt == IF_ID_RegRs &&
     ID_EX_RegRt == IF_ID_RegRt)
     begin
       pc = 0;
       ifid = 0;
       nop = 1;
     end
  else
    begin
      pc = 1;
      ifid = 1;
      nop = 0;
    end
end

assign PC_Write = pc;
assign IF_ID_Write = ifid;
assign NOP = nop;

endmodule
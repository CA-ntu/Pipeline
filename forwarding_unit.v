module forwarding_unit(
  EX_MEM_RegWrite,
  EX_MEM_RegRd,
  ID_EX_RegRs,
  ID_EX_RegRt,
  MEM_WB_RegWrite,
  MEM_WB_RegRd,
  Forward_A,
  Forward_B,
);

input EX_MEM_RegWrite;
input MEM_WB_RegWrite;
input[4:0] EX_MEM_RegRd;
input[4:0] MEM_WB_RegRd;
input[4:0] ID_EX_RegRs;
input[4:0] ID_EX_RegRt;

output[1:0] Forward_A;
output[1:0] Forward_B;

reg [1:0] A;
reg [1:0] B;

always@(*) 
begin
  if(EX_MEM_RegWrite &&
     EX_MEM_RegRd != 0 &&
     EX_MEM_RegRd == ID_EX_RegRs)
     A = 2'b10;
  else if(MEM_WB_RegWrite &&
          MEM_WB_RegRd != 0 &&
          MEM_WB_RegRd == ID_EX_RegRs)
     A = 2'b01;
  else
     A = 2'b00;
     
  if(EX_MEM_RegWrite &&
     EX_MEM_RegRd != 0 &&
     EX_MEM_RegRd == ID_EX_RegRt)
     B = 2'b10;
  else if(MEM_WB_RegWrite &&
          MEM_WB_RegRd != 0 &&
          MEM_WB_RegRd == ID_EX_RegRt)
     B = 2'b01;
  else
     B = 2'b00;
end

assign Forward_A = A;
assign Forward_B = B;

endmodule

  
  
  

  
    

module forwarding_unit(
  EX_MEM_RegWrite,
  EX_MEM_RegRd,
  ID_EX_RegRs,
  ID_EX_RegRt,
  MEM_WB_RegWrite,
  MEM_WB_RegRd,
  Forward_A,
  Forward_B
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
     EX_MEM_RegRd != 5'b00000 &&
     EX_MEM_RegRd == ID_EX_RegRs)
     A = 2'b10;
  else if(MEM_WB_RegWrite &&
          MEM_WB_RegRd != 5'b00000 &&
          MEM_WB_RegRd == ID_EX_RegRs)
     A = 2'b01;
  else
     A = 2'b00;
     
  if(EX_MEM_RegWrite &&
     EX_MEM_RegRd != 5'b00000 &&
     EX_MEM_RegRd == ID_EX_RegRt)
     B = 2'b10;
  else if(MEM_WB_RegWrite &&
          MEM_WB_RegRd != 5'b00000 &&
          MEM_WB_RegRd == ID_EX_RegRt)
     B = 2'b01;
  else
     B = 2'b00;
  /*
  $display( "\n");
  $display( "MEM_WB_RegWrite = %b,\n" , MEM_WB_RegWrite);
  $display( "MEM_WB_RegRd = %b,\n" , MEM_WB_RegRd);
  $display( "ID_EX_RegRs = %b,\n" , ID_EX_RegRs);
  $display( "\n");

  $display( "\n");
  $display( "EX_MEM_RegWrite = %b,\n" , EX_MEM_RegWrite);
  $display( "EX_MEM_RegRd = %b,\n" , EX_MEM_RegRd);
  $display( "ID_EX_RegRt = %b,\n" , ID_EX_RegRt);
  $display( "\n");
  */

end

assign Forward_A = A;
assign Forward_B = B;

endmodule

  
  
  

  
    

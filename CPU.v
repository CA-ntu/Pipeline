module CPU
(
	clk_i,
    rst_i,
    start_i
);

input               clk_i;  
input               rst_i;
input               start_i;

/* Address */
wire    [31:0]  inst_addr, inst;

wire	[31:0]	PC_in;
wire	[31:0]	PC_out;


/*ID*/
wire 	[4:0]	RSaddr; // inst[25:21]
wire 	[4:0]	RTaddr; // inst[20:16]
wire 	[4:0]	RDaddr; // inst[15:11]
wire 	[5:0]	Op; 		// inst[31:26]
wire 	[5:0]	Funct; 		// inst[5:0]
wire 	[15:0]	Immediate; 	// inst[15:0]



wire 	[31:0]	Immediate32;
wire 	[31:0]	ShiftLeft32;
wire    [31:0]  RSdata;
wire    [31:0]  RTdata;

wire    [31:0]  Add_PC_out;



/* Control Signal */


wire            PCWrite;
wire            RegWrite;
wire            IF_ID_Write;
wire            Eq;
wire            RegDst;
wire            ALUSrc;
wire    [1:0]   ALUOp;
wire    [2:0]   ALUCtrl;
wire            MemWrite;
wire            MemRead;
wire            MemtoReg;

/* by joris need to ask*/
wire            NOP; //same as stall
wire            Branch;
wire            Jump;
wire            ExtOp;



wire    [1:0]   ForwardA;
wire    [1:0]   ForwardB;


/* EX */


wire    [31:0]  MUX4_out;
wire    [31:0]  MUX6_out;
wire    [31:0]  MUX7_out;
wire    [31:0]  ALU_out;

wire    [31:0]  RSdata_EX;
wire    [31:0]  RTdata_EX;


wire    [31:0]  Immediate32_EX;


wire    [4:0]   MUX3_out;

wire    [4:0]   RSaddr_EX;
wire    [4:0]   RTaddr_EX;
wire    [4:0]   RDaddr_EX;


/* MEM */
wire    [31:0]  ALU_out_MEM;

wire    [31:0]  Memdata_in;
wire    [31:0]  Memdata_out;

wire    [4:0]   MUX3_out_MEM;





/* WB */
wire    [31:0]  Memdata_out_WB;

wire    [31:0]  ALU_out_WB;

wire    [4:0]   MUX3_out_WB;

wire    [31:0]  MUX5_out;



/* Left top */
wire    [31:0]  MUX1_out;

wire    [27:0]  ShiftLeft28;

wire    [31:0]  jump_addr;







/* IF/ID */
reg 	[31:0]	IF_ID_PC_out;
reg     [31:0]	IF_ID_inst;

/* ID/EX */
reg     [31:0]  ID_EX_RSdata;
reg     [31:0]  ID_EX_RTdata;
reg     [31:0]  ID_EX_Immediate32;
reg     [4:0]   ID_EX_RSaddr;
reg     [4:0]   ID_EX_RTaddr;
reg     [4:0]   ID_EX_RDaddr;

/* by joris need to ask*/
reg     [31:0]  ID_EX_inst;
reg             ID_EX_MemtoReg;
reg             ID_EX_RegWrite;
reg             ID_EX_MemRead;
reg             ID_EX_MemWrite;
reg             ID_EX_ALUSrc;
reg     [1:0]   ID_EX_ALUOp;
reg             ID_EX_RegDst;


/* EX/MEM */
reg     [31:0]  EX_MEM_ALU_out;
reg     [31:0]  EX_MEM_MUX7_out;
reg     [4:0]   EX_MEM_MUX3_out;
reg             EX_MEM_MemtoReg;
reg             EX_MEM_RegWrite;
reg             EX_MEM_MemRead;
reg             EX_MEM_MemWrite;
reg     [4:0]   EX_MEM_RSaddr;
reg     [4:0]   EX_MEM_RTaddr;
reg     [4:0]   EX_MEM_RDaddr;


/* MEM/WB */
reg     [31:0]  MEM_WB_ALU_out;
reg     [31:0]  MEM_WB_Memdata_out;
reg     [4:0]   MEM_WB_MUX3_out;
reg             MEM_WB_MemtoReg;
reg             MEM_WB_RegWrite;




assign  RSaddr[4:0] = IF_ID_inst[25:21];
assign  RTaddr[4:0] = IF_ID_inst[20:16];
assign  RDaddr[4:0] = IF_ID_inst[15:11];
assign  Op[5:0] = IF_ID_inst[31:26];
assign  Funct[5:0] = IF_ID_inst[5:0];
assign  Immediate[15:0] = IF_ID_inst[15:0];
assign  Immediate32_EX = ID_EX_Immediate32;
assign  RSaddr_EX = ID_EX_RSaddr;
assign  RTaddr_EX = ID_EX_RTaddr;
assign  RDaddr_EX = ID_EX_RDaddr;
assign ALU_out_MEM = EX_MEM_ALU_out;
assign Memdata_in = EX_MEM_MUX7_out;
assign MUX3_out_MEM = EX_MEM_MUX3_out;
assign  jump_addr = { {MUX1_out[3:0]} , ShiftLeft28 };
assign  RSdata_EX = ID_EX_RSdata;
assign  RTdata_EX = ID_EX_RTdata;
assign Memdata_out_WB = MEM_WB_Memdata_out;
assign ALU_out_WB = MEM_WB_ALU_out;
assign MUX3_out_WB = MEM_WB_MUX3_out;



PC PC(
    .clk_i      (clk_i),
    .start_i    (start_i),
    .PCWrite_i	(PCWrite),
    .pc_i       (PC_in),
    .pc_o       (inst_addr)
);

Adder Add_PC(
    .data1_i    (inst_addr),
    .data2_i    (32'd4),

    .data_o     (PC_out)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (inst)
);

/* by joris need to ask*/
control_unit Control(
    .op         (IF_ID_inst[31:26]),
    .RegDst     (RegDst),
    .ALUSrc     (ALUSrc),
    .MemtoReg   (MemtoReg),
    .RegWrite   (RegWrite),
    .MemWrite   (MemWrite),
    .Branch     (Branch), 
    .Jump       (Jump),
    .ExtOp      (ExtOp), 
    .ALUOp      (ALUOp),
    .MemRead    (MemRead)
);

forwarding_unit FU(
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    .EX_MEM_RegRd(EX_MEM_RDaddr),
    .ID_EX_RegRs(ID_EX_RSaddr),
    .ID_EX_RegRt(ID_EX_RTaddr),
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .MEM_WB_RegRd(MEM_WB_MUX3_out),
    .Forward_A(ForwardA),
    .Forward_B(ForwardB)
);


Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (RSaddr),
    .RTaddr_i   (RDaddr),
    .RDaddr_i   (MUX3_out_WB), 
    .RDdata_i   (MUX5_out),
    .RegWrite_i (MEM_WB_RegWrite), 
    .RSdata_o   (RSdata), 
    .RTdata_o   (RTdata) 
);

Sign_Extend Sign_Extend(
    .data_i     (Immediate),
    .data_o     (Immediate32)
);


Shift_Left_2 Shift_Left_2(
	.data_i 	(Immediate32),
	.data_o 	(ShiftLeft32)
);

Equal Equal(
    .data1_i    (RSdata),
    .data2_i    (RTdata),
    .Eq_o       (Eq)
);

Adder ADD(
    .data1_i    (ShiftLeft32),
    .data2_i    (IF_ID_PC_out),

    .data_o     (Add_PC_out)

);



MUX5_2to1 MUX3(
    .data1_i    (RTaddr_EX),
    .data2_i    (RDaddr_EX),     
    .select_i   (ID_EX_RegDst),
    .data_o     (MUX3_out)
);

MUX32_3to1 MUX6(
    .data1_i     (RSdata_EX),
    .data2_i     (MUX5_out),
    .data3_i     (ALU_out_MEM),
    .select_i    (ForwardA),
    .data_o      (MUX6_out)
);

MUX32_3to1 MUX7(
    .data1_i     (RTdata_EX),
    .data2_i     (MUX5_out),
    .data3_i     (ALU_out_MEM),
    .select_i    (ForwardB),
    .data_o      (MUX7_out)
);

MUX32_2to1 MUX4(
    .data1_i    (MUX7_out),
    .data2_i    (Immediate32_EX),     
    .select_i   (ID_EX_ALUSrc),
    .data_o     (MUX4_out)
);
ALUCtr_unit ALUCtr_unit(
	.ALUOp      (ID_EX_ALUOp),
	.func       (ID_EX_inst[5:0]),
	.ALUCtr     (ALUCtrl)
);
ALU ALU(
	.data1      (MUX6_out),
	.data2      (MUX4_out),
	.ALUCtr     (ALUCtrl),
	.dataout    (ALU_out_MEM)
);

hazard_detect HD(
    .ID_EX_MEM_Read (ID_EX_MEM_Read), 
    .ID_EX_RegRt  (ID_EX_inst[20:16]),
    .IF_ID_RegRs  (RSaddr),
    .IF_ID_RegRt  (RTaddr),
    .PC_Write     (PCWrite),
    .IF_ID_Write  (IF_ID_Write),
    .NOP          (NOP)
);


/* WB */
/* notice : MUX5's data1_i and data2_i
            different from other MUX32_2to1 */

MUX32_2to1 MUX5(
    .data1_i    (ALU_out_WB),
    .data2_i    (Memdata_out_WB),     
    .select_i   (MEM_WB_MemtoReg),
    .data_o     (MUX5_out)
);




/* MEM */

Data_Memory Data_Memory(
    .clk_i      (clk_i),
    .Address_i  (ALU_out_MEM),
    .Writedata_i(Memdata_in),
    .MemWrite_i (EX_MEM_MemWrite),
    .MemRead_i  (EX_MEM_MemRead),
    .Readdata_o (Memdata_out)
);


/* Left top */

MUX32_2to1 MUX2(
    .data1_i    (MUX1_out),
    .data2_i    (jump_addr),     
    .select_i   (Jump),
    .data_o     (PC_in)
);

MUX32_2to1 MUX1(
    .data1_i    (PC_out),
    .data2_i    (Add_PC_out),     
    .select_i   (Branch & Eq),
    .data_o     (MUX1_out)
);

Shift_Left_2_26to28 Shift_Left_2_26to28(
    .data_i     (IF_ID_inst[25:0]),
    .data_o     (ShiftLeft28)
);





always @(posedge clk_i) begin

	/* IF/ID */
	if(IF_ID_Write==1) begin
        IF_ID_inst <= inst;
        IF_ID_PC_out <= PC_out;
    end
    else begin
        //do not have to change?
    end
    /* ID/EX */
    if (NOP==0) begin //no need of mux8
        //WB
        ID_EX_MemtoReg <= MemtoReg;
        ID_EX_RegWrite <= RegWrite;
        //M
        ID_EX_MemRead <= MemRead; 
        ID_EX_MemWrite <= MemWrite;
        //EX
        ID_EX_ALUSrc <= ALUSrc;
        ID_EX_ALUOp <= ALUOp;
        ID_EX_RegDst <= RegDst;
    end
    else begin
        //WB
        ID_EX_MemtoReg <= 0;
        ID_EX_RegWrite <= 0;
        //M
        ID_EX_MemRead <= 0; 
        ID_EX_MemWrite <= 0;
        //EX
        ID_EX_ALUSrc <= 0;
        ID_EX_ALUOp <= 2'b00;
        ID_EX_RegDst <= 0;
    end
    ID_EX_RSdata <= RSdata;
    ID_EX_RTdata <= RTdata;
    ID_EX_Immediate32 <= Immediate32;
    ID_EX_RSaddr <= RSaddr;
    ID_EX_RTaddr <= RTaddr;
    ID_EX_RDaddr <= RDaddr;
    ID_EX_inst <= IF_ID_inst;

    /* EX/MEM */
    //WB
    EX_MEM_MemtoReg <= ID_EX_MemtoReg;
    EX_MEM_RegWrite <= ID_EX_RegWrite;
    //M
    EX_MEM_MemRead <= ID_EX_MemRead; 
    EX_MEM_MemWrite <= ID_EX_MemWrite;
    // temp
    EX_MEM_ALU_out <= ALU_out;
    EX_MEM_MUX7_out <= MUX7_out;
    EX_MEM_MUX3_out <= MUX3_out;
    // register addr
    EX_MEM_RSaddr <= ID_EX_RSaddr;
    EX_MEM_RTaddr <= ID_EX_RTaddr;
    EX_MEM_RDaddr <= ID_EX_RDaddr;


    /* MEM/WB */
    //WB
    MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
    MEM_WB_RegWrite <= EX_MEM_RegWrite;
    // temp
    MEM_WB_Memdata_out <= Memdata_out;
    MEM_WB_ALU_out <= ALU_out_MEM;
    MEM_WB_MUX3_out <= MUX3_out_MEM;
	
 end

 endmodule
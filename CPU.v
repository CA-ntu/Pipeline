module CPU
(
	clk_i,
    start_i
);

input               clk_i;
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


assign	RSaddr[4:0] = IF_ID_inst[25:21];
assign	RTaddr[4:0] = IF_ID_inst[20:16];
assign	RDaddr[4:0] = IF_ID_inst[15:11];
assign 	Op[5:0] = IF_ID_inst[31:26];
assign 	Funct[5:0] = IF_ID_inst[5:0];
assign 	Immediate[15:0] = IF_ID_inst[15:0];


wire 	[31:0]	Immediate32;
wire 	[31:0]	ShiftLeft;
wire    [31:0]  RSdata;
wire    [31:0]  RTdata;

wire    [31:0]  Add_PC_out;



/* Control Signal */
wire			PCWrite;
wire 			IF_ID_Write;
wire            NOP; //same as hazard_detect
wire            RegDst;
wire            ALUSrc;
wire            MemtoReg;
wire   			RegWrite;
wire            MemWrite;
wire            Branch;
wire            Jump;
wire            ExtOp;
wire            Eq;
wire    [1:0]   ALUOp;

wire    [1:0]   ForwardA;
wire    [1:0]   ForwardB;


/* EX */


wire    [31:0]  MUX4_out;
wire    [31:0]  MUX6_out;
wire    [31:0]  MUX7_out;

wire    [31:0]  RSdata_EX;
wire    [31:0]  RTdata_EX;
assign  RSdata_EX = ID_EX_RSdata;
assign  RTdata_EX = ID_EX_RTdata;



wire    [4:0]   MUX3_out;

wire    [4:0]   RSaddr_EX;
wire    [4:0]   RTaddr_EX;
wire    [4:0]   RDaddr_EX;

assign  RSaddr_EX = ID_EX_inst[25:21];
assign  RTaddr_EX = ID_EX_inst[20:16];
assign  RDaddr_EX = ID_EX_inst[15:11];

/* MEM */

wire    [31:0]  ALU_out_MEM;



/* WB */

wire    [31:0]  MUX5_out;




/* IF/ID */
reg 	[31:0]	IF_ID_PC_out;
reg     [31:0]	IF_ID_inst;

/* ID/EX */
reg     [31:0]  ID_EX_RSdata;
reg     [31:0]  ID_EX_RTdata;
reg     [31:0]  ID_EX_Immediate32;
reg     [31:0]  ID_EX_inst;
reg             ID_EX_MemtoReg;
reg             ID_EX_RegWrite;
reg             ID_EX_MemRead;//?
reg             ID_EX_MemWrite;
reg             ID_EX_ALUSrc;
reg     [1:0]   ID_EX_ALUOp;
reg             ID/EX_RegDst;

/* EX/MEM */





PC PC(
    .clk_i      (clk_i),
    .start_i    (start_i),
    .PCWrite_i	(PCWrite),
    .pc_i       (PC_in),
    .pc_o       (inst_addr)
);

Adder Add_PC(
    .data1_i   (inst_addr),
    .data2_i   (32'd4),

    .data_o     (PC_out)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (inst)
);

Control Control(
    .op         (IF_ID_inst[31:26]),
    .RegDst     (RegDst),
    .ALUSrc     (ALUSrc),
    .MemtoReg   (MemtoReg),
    .RegWrite   (RegWrite),
    .MemWrite   (MemWrite),
    .Branch     (Branch), //branch?
    .Jump       (Jump),
    .ExtOp      (ExtOp), //memread?
    .ALUOp      (ALUOp),
);


Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (RSaddr),
    .RTaddr_i   (RDaddr),
    .RDaddr_i   (), 
    .RDdata_i   (),
    .RegWrite_i (RegWrite), 
    .RSdata_o   (RSdata), 
    .RTdata_o   (RTdata) 
);

Sign_Extend Sign_Extend(
    .data_i     (Immediate),
    .data_o     (Immediate32)
);


Shift_Left_2 Shift_Left_2(
	.data_i 	(Immediate32),
	.data_o 	(ShiftLeft)
);

Equal Equal(
    .data1_i    (RSdata),
    .data2_i    (RTdata),
    .Eq_o       (Eq)
);

Adder ADD(
    .data1_i    (ShiftLeft),
    .data2_i    (IF_ID_PC_out),

    .data_o     (Add_PC_out)

);



MUX5_2to1 MUX3(
    .data1_i    (RTdata_EX),
    .data2_i    (RDaddr_EX),     
    .select_i   (RegDst),
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

hazard_detect HD(
    .ID_EX_MEM_Read (), 
    .ID_EX_RegRt  (),
    .IF_ID_RegRs  (RSaddr),
    .IF_ID_RegRt  (RTaddr),
    .PC_Write     (PCWrite),
    .IF_ID_Write  (IF_ID_Write),
    .NOP          (NOP)
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
        ID_EX_MemRead <= MemRead; //need fixed
        ID_EX_MemWrite <= MemWrite;
        //EX
        ID_EX_ALUSrc <= ALUSrc;
        ID_EX_ALUOp <= ALUOp;
        ID/EX_RegDst <= RegDst;
    end
    else begin
        ID_EX_MemtoReg <= 0;
        ID_EX_RegWrite <= 0;
        //M
        ID_EX_MemRead <= 0; //need fixed
        ID_EX_MemWrite <= 0;
        //EX
        ID_EX_ALUSrc <= 0;
        ID_EX_ALUOp <= 2'b00;
        ID/EX_RegDst <= 0;
    end
    ID_EX_RSdata <= RSdata;
    ID_EX_RTdata <= RTdata;
    ID_EX_Immediate32 <= Immediate32;
    ID_EX_inst <= IF_ID_inst;
    /* EX/MEM */
	
	

end
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


/* */
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
wire   			RegWrite;
wire 			IF_ID_Write;
wire            Eq;







/* IF/ID */
reg 	[31:0]	IF_ID_PC_out;
reg     [31:0]	IF_ID_inst;






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
    .data1_i   (ShiftLeft),
    .data2_i   (IF_ID_PC_out),

    .data_o     (Add_PC_out)

);


always @(posedge clk_i) begin

	/* IF/ID */
	/* 
		TODO 
	*/
	// temp
	IF_ID_inst <= inst;
	IF_ID_PC_out <= PC_out;
	
	

end
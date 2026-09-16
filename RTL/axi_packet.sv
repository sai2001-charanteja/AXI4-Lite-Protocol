typedef enum {OKAY, EXOKAY, SLVERR, DECERR} respCode;
typedef enum {OP_IDLE, OP_RD, OP_WR, OP_RW} op_trnx;
typedef enum {RESET,STIMULUS} pkt_kind;
class axi_packet;
	
	/*
		0. Write Transaction
		1. Read Transaction
		2. Read - Write Transaction
	*/
	rand op_trnx operation;

	rand logic [ADDRESS_WIDTH-1:0] aw_addr;
	rand logic [ADDRESS_WIDTH-1:0] ar_addr;
	rand logic [DATA_WIDTH-1:0] w_data;
	rand logic [STRB_WIDTH-1:0] w_strb;

	rand logic [DELAY_WIDTH-1:0]aw_del;  // Initial dealy before Driving AW signals 
	rand logic [DELAY_WIDTH-1:0]w_del; // Initial dealy before Driving W signals 
	rand logic [DELAY_WIDTH-1:0]aw_r_del;	// Delay between write and read transaction
	rand logic [DELAY_WIDTH-1:0]r_aw_del; // Delay between Read and Write transaction
	rand logic [DELAY_WIDTH-1:0]initial_r_del; // Initial dealy before Driving AR signals 
	logic [DATA_WIDTH-1:0] r_data;
	pkt_kind kind;
	bit [31:0] reset_cycles;
	
	constraint valid {
		aw_addr inside {[0:ADDRESS_WIDTH-1]};
		ar_addr inside {[0:ADDRESS_WIDTH-1]};
		ar_addr != aw_addr;
		w_data inside {[0:255]};
		w_strb inside {[0:(1<< STRB_WIDTH)-1]};
		operation dist {OP_IDLE,OP_RD:=2,OP_WR:=2,OP_RW:=1};
	}

	constraint delay_valid{ // Randomizing the delays
		aw_del inside {[0:$]};
		w_del inside {[0:$]};
		
		aw_r_del inside {[0:$]};
		r_aw_del inside {[0:$]};
		initial_r_del inside {[0:$]};
	}
	
	function automatic void print_read_op_info();
		$display("[Read], RW [ADDR = %0d]",this.ar_addr);
	endfunction
	
	function automatic void print_write_op_info();
		$display("[Write], AW[ADDR = %0d], W[DATA = %0d, STRB = %0d]",this.aw_addr,this.w_data,this.w_strb);
	endfunction
	
	function automatic void print();
		case(this.operation)
			OP_IDLE:
				$display("Idle Packet");
			OP_RD:
				print_read_op_info();
			OP_WR:
				print_write_op_info();
			OP_RW:
			begin
				$display("****[Rd-Wr]****");
				print_read_op_info();
				print_write_op_info();
			end
		endcase
	endfunction
	
	function void copy(axi_packet rhs);
		if(rhs == null) begin
			$display("[Packet-Copy] Null Packet receieved");
			return;
		end
		
		this.operation = rhs.operation;
		this.reset_cycles = rhs.reset_cycles;
		this.aw_addr=rhs.aw_addr;
		this.ar_addr=rhs.ar_addr;
		this.w_data =rhs.w_data;
		this.w_strb=rhs.w_strb;
		
		this.aw_del=rhs.aw_del;  
		this.w_del=rhs.w_del; 
		this.aw_r_del=rhs.aw_r_del;
		this.r_aw_del =rhs.r_aw_del;
		this.initial_r_del = rhs.initial_r_del;
		
	endfunction
	

	
	function void post_randomize();
		print();
	endfunction

endclass
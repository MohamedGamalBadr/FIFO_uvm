module FIFO(FIFO_if.DUT f_if); 

logic [f_if.FIFO_WIDTH-1:0] data_in;
logic clk, rst_n, wr_en, rd_en;
logic [f_if.FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

assign data_in=f_if.data_in;
assign clk = f_if.clk;
assign rst_n=f_if.rst_n;
assign wr_en = f_if.wr_en;
assign rd_en = f_if.rd_en;
assign  f_if.data_out = data_out ;
assign  f_if.wr_ack = wr_ack ;
assign  f_if.overflow = overflow ;
assign  f_if.full = full ;
assign f_if.empty = empty ;
assign  f_if.almostfull = almostfull;
assign f_if.almostempty = almostempty ;
assign f_if.underflow =  underflow;
 
localparam max_fifo_addr = $clog2(f_if.FIFO_DEPTH);

reg [f_if.FIFO_WIDTH-1:0] mem [f_if.FIFO_DEPTH-1:0];

logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
logic [max_fifo_addr:0] count;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0;
		wr_ack <= 0; 
	end
	else if (wr_en && count < f_if.FIFO_DEPTH) begin
		mem[wr_ptr] <= data_in;
		wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		wr_ack <= 0; 
	end
	if (full && wr_en && rst_n)
			overflow <= 1;
		else
			overflow <= 0;
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0;
	end
	else if (rd_en && count != 0) begin
		data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
		if (empty && rd_en && rst_n)
			underflow <=1;
		else 
			underflow <=0;
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if	( (({wr_en, rd_en} == 2'b10) && !full) || ( ({wr_en, rd_en} == 2'b11) && empty) ) 
			count <= count + 1;
		else if ( (({wr_en, rd_en} == 2'b01) && !empty) || ( ({wr_en, rd_en} == 2'b11) && full) )
			count <= count - 1;
	end
end

assign full = (count == f_if.FIFO_DEPTH)? 1 : 0;
assign empty = (count == 0)? 1 : 0;
assign almostfull = (count == f_if.FIFO_DEPTH-1)? 1 : 0; 
assign almostempty = (count == 1)? 1 : 0;

endmodule
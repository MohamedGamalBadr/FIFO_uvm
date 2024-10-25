module FIFO_SVA (FIFO_if.DUT f_if);
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
assign  data_out = f_if.data_out ;
assign  wr_ack = f_if.wr_ack ;
assign  overflow = f_if.overflow ;
assign  full = f_if.full ;
assign empty = f_if.empty ;
assign  almostfull = f_if.almostfull;
assign almostempty = f_if.almostempty ;
assign underflow =  f_if.underflow;

always_comb begin
	if(~rst_n) 
	a_reset: assert final ((DUT.rd_ptr == 0 && DUT.wr_ptr == 0 && DUT.count == 0 && full == 0 && almostfull == 0 && empty == 1 && almostempty == 0 && underflow == 0 && overflow == 0));
end

property increase_count_pr;
	@(posedge clk) disable iff (~rst_n) ((wr_en && !rd_en && !full) || ( ({wr_en, rd_en} == 2'b11) && empty) ) |=> (DUT.count == $past(DUT.count) + 1);
endproperty

property decrease_count_pr;
	@(posedge clk) disable iff (~rst_n) ((!wr_en && rd_en && !empty) || ( ({wr_en, rd_en} == 2'b11) && full)) |=>  (DUT.count == $past(DUT.count) - 1);
endproperty

property wr_ptr_pr;
	@(posedge clk) disable iff (~rst_n) (wr_en && !full) |=>  (DUT.wr_ptr == ($past(DUT.wr_ptr) + 1)% f_if.FIFO_DEPTH);
endproperty

property rd_ptr_pr;
	@(posedge clk) disable iff (~rst_n) (rd_en && !empty) |=> (DUT.rd_ptr == ($past(DUT.rd_ptr) + 1)% f_if.FIFO_DEPTH);
endproperty

property full_pr;
	@(posedge clk)  (DUT.count == f_if.FIFO_DEPTH) |-> (full);
endproperty

property almostfull_pr;
	@(posedge clk)  (DUT.count == f_if.FIFO_DEPTH-1) |-> (almostfull);
endproperty

property empty_pr;
	@(posedge clk)  (DUT.count == 0) |-> (empty);
endproperty

property almostempty_pr;
	@(posedge clk)  (DUT.count == 1) |-> (almostempty);
endproperty

property overflow_pr;
	@(posedge clk) disable iff (~rst_n) (full && wr_en) |=> (overflow);
endproperty

property underflow_pr;
	@(posedge clk) disable iff (~rst_n) (empty && rd_en) |=> (underflow);
endproperty

assert property(increase_count_pr);
cover property(increase_count_pr);

assert property(decrease_count_pr);
cover property(decrease_count_pr);

assert property(wr_ptr_pr);
cover property(wr_ptr_pr);

assert property(rd_ptr_pr);
cover property(rd_ptr_pr);

assert property(full_pr);
cover property(full_pr);

assert property(almostfull_pr);
cover property(almostfull_pr);

assert property(empty_pr);
cover property(empty_pr);

assert property(almostempty_pr);
cover property(almostempty_pr);

assert property(overflow_pr);
cover property(overflow_pr);

assert property(underflow_pr);
cover property(underflow_pr);
endmodule
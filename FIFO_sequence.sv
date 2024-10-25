package FIFO_sequence_pkg;
	import FIFO_seq_item_pkg::*;
	import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_reset_sequence extends uvm_sequence #(FIFO_seq_item);
     `uvm_object_utils(FIFO_reset_sequence)
     FIFO_seq_item seq_item;

     function new (string name = "FIFO_reset_sequence");
		super.new(name);
	endfunction

	task body;
		seq_item = FIFO_seq_item::type_id::create("seq_item");
		start_item(seq_item);
		seq_item.rst_n=0;
		seq_item.data_in=0;
		seq_item.wr_en=0;
		seq_item.rd_en=0;
		finish_item(seq_item);
	endtask
endclass

class write_read_sequence extends uvm_sequence #(FIFO_seq_item);
     `uvm_object_utils(write_read_sequence)
     FIFO_seq_item seq_item;

     function new (string name = "write_read_sequence");
		super.new(name);
	endfunction

	task body;
		repeat(10000) begin
		    seq_item = FIFO_seq_item::type_id::create("seq_item");
		    start_item(seq_item);
            assert(seq_item.randomize());
		    finish_item(seq_item);
	   end
	endtask
endclass


class write_sequence extends uvm_sequence #(FIFO_seq_item);
     `uvm_object_utils(write_sequence)
     FIFO_seq_item seq_item;

     function new (string name = "write_sequence");
		super.new(name);
	endfunction

	task body;
		repeat(20) begin
		    seq_item = FIFO_seq_item::type_id::create("seq_item");
		    start_item(seq_item);
            assert(seq_item.randomize());
            seq_item.rst_n=1;
            seq_item.rd_en=0;
		    finish_item(seq_item);
	   end
	endtask
endclass

class read_sequence extends uvm_sequence #(FIFO_seq_item);
     `uvm_object_utils(read_sequence)
     FIFO_seq_item seq_item;

     function new (string name = "read_sequence");
		super.new(name);
	endfunction

	task body;
		repeat(20) begin
		    seq_item = FIFO_seq_item::type_id::create("seq_item");
		    start_item(seq_item);
            assert(seq_item.randomize());
            seq_item.rst_n=1;
            seq_item.wr_en=0;
		    finish_item(seq_item);
	   end
	endtask
endclass
endpackage
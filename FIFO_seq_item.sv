package FIFO_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_seq_item extends uvm_sequence_item;
	`uvm_object_utils(FIFO_seq_item)
	parameter FIFO_WIDTH = 16;
    rand logic rst_n;
    rand bit [FIFO_WIDTH-1:0] data_in;
    rand bit wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;
    integer RD_EN_ON_DIST, WR_EN_ON_DIST;

    function new (string name = "FIFO_seq_item", integer RD_EN_ON_DIST = 30 , integer WR_EN_ON_DIST = 70);
		super.new(name);
		this.RD_EN_ON_DIST = RD_EN_ON_DIST;
	    this.WR_EN_ON_DIST = WR_EN_ON_DIST;
	endfunction

	constraint assert_reset {
	    rst_n dist {0:=5, 1:=95};
    }
    constraint write_enable {
	    wr_en dist {1:=this.WR_EN_ON_DIST, 0:=100 - this.WR_EN_ON_DIST};
    }

    constraint read_enable {
     	rd_en dist {1:=this.RD_EN_ON_DIST, 0:= 100 - this.RD_EN_ON_DIST};
    }

	function string convert2string();
        return $sformatf("%s rst_n = 0b%0b, data_in = 0x%0h, wr_en = 0b%0b, rd_en = 0b%0b, data_out = 0x%0h, wr_ack = 0b%0b, overflow = 0b%0b, full = 0b%0b, empty = 0b%0b, almostfull = 0b%0b, almostempty = 0b%0b, underflow = 0b%0b",super.convert2string(), 
        	rst_n, data_in, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
	endfunction

	function string convert2string_stimulus();
        return $sformatf(" rst_n = 0b%0b, data_in = 0x%0h, wr_en = 0b%0b, rd_en = 0b%0b", 
        	rst_n, data_in, wr_en, rd_en);
	endfunction 


endclass
endpackage
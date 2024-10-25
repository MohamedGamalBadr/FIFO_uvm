package FIFO_coverage_pkg;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_coverage extends uvm_component;
	`uvm_component_utils(FIFO_coverage); 
	uvm_analysis_export #(FIFO_seq_item) cov_export;
	uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;

	FIFO_seq_item seq_item_cov;

	 covergroup cross_coverage;

          wr_en_cvr: coverpoint seq_item_cov.wr_en;
          rd_en_cvr: coverpoint seq_item_cov.rd_en;
          full_cvr: coverpoint seq_item_cov.full;
          overflow_cvr: coverpoint seq_item_cov.overflow;
          underflow_cvr: coverpoint seq_item_cov.underflow;
          wr_ack_cvr: coverpoint seq_item_cov.wr_ack;
         empty_cvr: coverpoint seq_item_cov.empty;

        	cross_WR_RD_full: cross seq_item_cov.wr_en, rd_en_cvr, full_cvr{
               //It is impossibl to have rd_en high and full flag high at the same time
               illegal_bins rd_en_and_full_high =  binsof(rd_en_cvr) intersect {1} && binsof(full_cvr) intersect {1};
          }
        	cross_WR_RD_almost_full: cross seq_item_cov.wr_en, seq_item_cov.rd_en, seq_item_cov.almostfull;
        	cross_WR_RD_empty: cross wr_en_cvr, seq_item_cov.rd_en, empty_cvr{
        	    //It is impossibl to have wr_en high and empty flag high at the same time
        	     illegal_bins wr_en_and_empty_high = binsof(empty_cvr) intersect {1} && binsof(wr_en_cvr) intersect {1};
        	}      
         	cross_WR_RD_almost_empty: cross seq_item_cov.wr_en, seq_item_cov.rd_en, seq_item_cov.almostempty;
        	cross_WR_RD_overflow: cross wr_en_cvr, seq_item_cov.rd_en, overflow_cvr{
              //It is impossibl to have wr_en low and overflow flag high at the same time
              illegal_bins wr_en_low_overflow_high =  binsof(wr_en_cvr) intersect {0} && binsof(overflow_cvr) intersect {1};
          }
        	cross_WR_RD_underflow: cross seq_item_cov.wr_en, rd_en_cvr, underflow_cvr{
              //It is impossibl to have rd_en low and underflow flag high at the same time
              illegal_bins rd_en_low_underflow_high =  binsof(rd_en_cvr) intersect {0} && binsof(underflow_cvr) intersect {1};
          }
        	cross_WR_RD_wr_ack: cross wr_en_cvr, seq_item_cov.rd_en, wr_ack_cvr {
              //It is impossibl to have wr_en low and wr_ack flag high at the same time
              illegal_bins wr_en_low_wr_ack_high =  binsof(wr_en_cvr) intersect {0} && binsof(wr_ack_cvr) intersect {1};
          }
        endgroup


	 function new(string name = "FIFO_coverage", uvm_component parent = null);
		super.new(name, parent);
		cross_coverage = new ();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cov_export = new("cov_export", this);
		cov_fifo = new ("cov_fifo", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		cov_export.connect(cov_fifo.analysis_export);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			cov_fifo.get(seq_item_cov);
			cross_coverage.sample();
		end
	endtask
endclass
endpackage
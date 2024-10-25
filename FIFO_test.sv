package FIFO_test_pkg;
import FIFO_env_pkg::*;
import FIFO_config_pkg::*;
import FIFO_sequence_pkg::*;
import uvm_pkg::*;
 `include "uvm_macros.svh"
class FIFO_test extends uvm_test;
	`uvm_component_utils(FIFO_test);

	FIFO_env env;

	FIFO_config FIFO_cfg;
    virtual FIFO_if FIFO_vif;
	FIFO_reset_sequence reset_seq;
	write_read_sequence write_read_seq;
	write_sequence write_seq;
    read_sequence read_seq;
	function new(string name = "FIFO_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = FIFO_env::type_id::create("env", this);
		FIFO_cfg = FIFO_config::type_id:: create("FIFO_cfg");
        write_read_seq = write_read_sequence::type_id:: create("write_read_seq");
        reset_seq = FIFO_reset_sequence::type_id:: create("reset_seq");
        write_seq = write_sequence::type_id::create("write_seq");
        read_seq = read_sequence::type_id::create("read_seq");

		if(!uvm_config_db #(virtual FIFO_if)::get(this, "", "FIFO_IF",FIFO_cfg.FIFO_vif ))
			`uvm_fatal("build_phase", "Test - Unable to get the virtual interface of the shift reg from the uvm_config_db");

		uvm_config_db #(FIFO_config)::set(this, "*", "CFG", FIFO_cfg);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		//reset sequence 
         `uvm_info("run_phase", "Reset Asserted", UVM_LOW)
          reset_seq.start(env.agt.sqr);
		 `uvm_info("run_phase", "Reset Deasserted", UVM_LOW)

		  //write_only_sequence
		  `uvm_info("run_phase", "Stimulus Generation of write sequence Started", UVM_LOW)
          write_seq.start(env.agt.sqr);
		 `uvm_info("run_phase", "Stimulus Generation of write sequence Ended", UVM_LOW)

		  //read_only_sequence
		  `uvm_info("run_phase", "Stimulus Generation of read sequence Started", UVM_LOW)
          read_seq.start(env.agt.sqr);
		 `uvm_info("run_phase", "Stimulus Generation  of read sequence Ended", UVM_LOW)

		 //write_read sequence
		  `uvm_info("run_phase", "Stimulus Generation of write_read sequence Started", UVM_LOW)
          write_read_seq.start(env.agt.sqr);
		 `uvm_info("run_phase", "Stimulus Generation of write_read sequence Ended", UVM_LOW)
         
		phase.drop_objection(this);
	endtask
endclass
endpackage
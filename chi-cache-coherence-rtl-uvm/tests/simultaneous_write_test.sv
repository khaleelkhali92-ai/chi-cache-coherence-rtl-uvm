class simultaneous_write_test extends my_chi_test;

    `uvm_component_utils(simultaneous_write_test)


    function new(string name = "simultaneous_write_test",
                 uvm_component parent = null);

        super.new(name, parent);

    endfunction


    task run_phase(uvm_phase phase);

        my_chi_write_seq write_seq0;
       my_chi_write_seq write_seq1;

        phase.raise_objection(this);
      
      
      write_seq0 = my_chi_write_seq::type_id::create("write_seq0");
      write_seq1 = my_chi_write_seq::type_id::create("write_seq1");

      write_seq0.seq_addr = 32'h00000100;
      write_seq0.seq_data = 32'hAAAAAAAA;

      write_seq1.seq_addr = 32'h00000100;
      write_seq1.seq_data = 32'hBBBBBBBB;
fork
    write_seq0.start(env.rn0_agt.seqr);
    write_seq1.start(env.rn1_agt.seqr);
join
        
#100;

        phase.drop_objection(this);

    endtask

endclass
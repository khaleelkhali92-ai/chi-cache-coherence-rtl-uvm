class rn1write_rn0read_test extends my_chi_test;

    `uvm_component_utils(rn1write_rn0read_test)


    function new(string name = "rn1write_rn0read_test",
                 uvm_component parent = null);

        super.new(name, parent);

    endfunction

    task run_phase(uvm_phase phase);

        my_chi_write_seq write_seq;
        my_chi_read_seq  read_seq;

        phase.raise_objection(this);

        write_seq = my_chi_write_seq::type_id::create("write_seq");
      write_seq.seq_addr = 32'h00000180;
      write_seq.seq_data = 32'h44444444;

      write_seq.start(env.rn1_agt.seqr);

        read_seq = my_chi_read_seq::type_id::create("read_seq");

      read_seq.start(env.rn0_agt.seqr); 

        phase.drop_objection(this);

    endtask

endclass
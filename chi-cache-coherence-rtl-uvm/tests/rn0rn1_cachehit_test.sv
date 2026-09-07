class rn0rn1_cachehit_test extends my_chi_test;

    `uvm_component_utils(rn0rn1_cachehit_test)

    function new(string name = "rn0rn1_cachehit_test",
                 uvm_component parent = null);

        super.new(name, parent);

    endfunction


    task run_phase(uvm_phase phase);

        my_chi_write_seq write_seq;
        my_chi_read_seq  read_seq0;
        my_chi_read_seq  read_seq1;

        phase.raise_objection(this);

        write_seq = my_chi_write_seq::type_id::create("write_seq");
      write_seq.seq_addr = 32'h00000300;
      write_seq.seq_data = 32'h66666666;

      write_seq.start(env.rn0_agt.seqr);

        read_seq0 = my_chi_read_seq::type_id::create("read_seq0");

      read_seq0.start(env.rn0_agt.seqr);

        read_seq1 = my_chi_read_seq::type_id::create("read_seq1");

      read_seq1.start(env.rn1_agt.seqr);

        phase.drop_objection(this);

    endtask

endclass
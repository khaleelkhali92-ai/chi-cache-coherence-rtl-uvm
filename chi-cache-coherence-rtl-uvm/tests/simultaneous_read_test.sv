class simultaneous_read_test extends my_chi_test;

    `uvm_component_utils(simultaneous_read_test)


    function new(string name = "simultaneous_read_test",
                 uvm_component parent = null);

        super.new(name, parent);

    endfunction

    task run_phase(uvm_phase phase);

        my_chi_read_seq  read_seq0;
        my_chi_read_seq read_seq1;

        phase.raise_objection(this);
      
      
      read_seq0 = my_chi_read_seq::type_id::create("read_seq0");
      read_seq1 = my_chi_read_seq::type_id::create("read_seq1");

fork
    read_seq0.start(env.rn0_agt.seqr);
    read_seq1.start(env.rn1_agt.seqr);
join

        phase.drop_objection(this);

    endtask

endclass
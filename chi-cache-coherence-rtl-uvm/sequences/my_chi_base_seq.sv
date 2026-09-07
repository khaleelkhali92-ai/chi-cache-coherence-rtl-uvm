class my_chi_base_seq extends uvm_sequence #(my_chi_transaction);

    `uvm_object_utils(my_chi_base_seq)

    function new(string name="my_chi_base_seq");
        super.new(name);
    endfunction

endclass
class my_chi_sequencer extends uvm_sequencer #(my_chi_transaction);
    `uvm_component_utils(my_chi_sequencer)

    function new(string name = "my_chi_sequencer",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass
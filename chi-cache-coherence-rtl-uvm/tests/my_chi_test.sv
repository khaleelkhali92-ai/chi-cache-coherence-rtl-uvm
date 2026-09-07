class my_chi_test extends uvm_test;

    `uvm_component_utils(my_chi_test)

    my_chi_env env;

    function new(string name = "my_chi_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = my_chi_env::type_id::create("env", this);

    endfunction

endclass
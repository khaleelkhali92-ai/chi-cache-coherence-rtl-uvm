class my_chi_agent extends uvm_component;

    `uvm_component_utils(my_chi_agent)

    my_chi_driver    drv;
    my_chi_monitor   mon;
    my_chi_sequencer seqr;

    bit is_rn0;


    function new(string name = "my_chi_agent",
                 uvm_component parent = null);

        super.new(name, parent);

    endfunction


    function void build_phase(uvm_phase phase);

        super.build_phase(phase);


        if (!uvm_config_db#(bit)::get(this, "", "is_rn0", is_rn0))
            `uvm_fatal("AGENT",
                       "is_rn0 configuration not found")


        // Pass RN information to driver and monitor
        uvm_config_db#(bit)::set(this, "drv", "is_rn0", is_rn0);

        uvm_config_db#(bit)::set(this, "mon", "is_rn0", is_rn0);


        drv  = my_chi_driver::type_id::create("drv", this);

        mon  = my_chi_monitor::type_id::create("mon", this);

        seqr = my_chi_sequencer::type_id::create("seqr", this);

    endfunction


    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        drv.seq_item_port.connect(seqr.seq_item_export);

    endfunction

endclass
class my_chi_env extends uvm_env;

    `uvm_component_utils(my_chi_env)

    my_chi_agent      rn0_agt;
    my_chi_agent      rn1_agt;

    my_chi_scoreboard sb;


    function new(string name = "my_chi_env",
                 uvm_component parent = null);

        super.new(name, parent);

    endfunction


    function void build_phase(uvm_phase phase);

        super.build_phase(phase);


        // Configure RN0
        uvm_config_db#(bit)::set(this,
                                 "rn0_agt",
                                 "is_rn0",
                                 1'b1);


        // Configure RN1
        uvm_config_db#(bit)::set(this,
                                 "rn1_agt",
                                 "is_rn0",
                                 1'b0);


        // Create agents
        rn0_agt = my_chi_agent::type_id::create("rn0_agt", this);

        rn1_agt = my_chi_agent::type_id::create("rn1_agt", this);


        // Create scoreboard
        sb = my_chi_scoreboard::type_id::create("sb", this);

    endfunction


    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);


        // RN0 monitor -> scoreboard
        rn0_agt.mon.mon_ap.connect(sb.analysis_export);


        // RN1 monitor -> scoreboard
        rn1_agt.mon.mon_ap.connect(sb.analysis_export);

    endfunction

endclass
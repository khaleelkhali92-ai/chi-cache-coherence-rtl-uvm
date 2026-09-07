class my_chi_monitor extends uvm_monitor;

    `uvm_component_utils(my_chi_monitor)

    virtual my_chi_if vif;

    uvm_analysis_port #(my_chi_transaction) mon_ap;

    bit is_rn0;

    // Store pending read request information
    bit        pending_read;
    bit [31:0] pending_addr;


    function new(string name = "my_chi_monitor",
                 uvm_component parent = null);

        super.new(name, parent);
        mon_ap = new("mon_ap", this);

    endfunction


    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if (!uvm_config_db#(virtual my_chi_if)::get(this,
                                                     "",
                                                     "vif",
                                                     vif))
            `uvm_fatal("MONITOR",
                       "Cannot get Interface")

        if (!uvm_config_db#(bit)::get(this,
                                      "",
                                      "is_rn0",
                                      is_rn0))
            `uvm_fatal("MONITOR",
                       "Cannot get is_rn0 configuration")

    endfunction


    task run_phase(uvm_phase phase);

        fork
            monitor_request();
            monitor_response();
        join

    endtask


     =====
    // REQUEST MONITOR
     =====

    task monitor_request();

        my_chi_transaction tr;

        forever begin

            @(posedge vif.clk);


            // =============================================
            // RN0
            // =============================================

            if (is_rn0) begin

                // -------------------------
                // RN0 WRITE
                // -------------------------

                if (vif.cpu0_write_valid) begin

                    tr = my_chi_transaction::type_id::create("tr");
                  tr.is_rn0 = is_rn0 ? 1'b1 : 1'b0;

                    tr.is_write   = 1'b1;
                    tr.addr       = vif.cpu0_write_addr;
                    tr.write_data = vif.cpu0_write_data;

                    `uvm_info("RN0_MONITOR",
                        $sformatf(
                            "WRITE REQUEST ADDR=%h DATA=%h",
                            tr.addr,
                            tr.write_data),
                        UVM_MEDIUM)

                    mon_ap.write(tr);

                end


                // -------------------------
                // RN0 READ
                // -------------------------

                else if (vif.cpu0_read_valid) begin

                    pending_read = 1'b1;
                    pending_addr = vif.cpu0_read_addr;

                    `uvm_info("RN0_MONITOR",
                        $sformatf(
                            "READ REQUEST ADDR=%h",
                            pending_addr),
                        UVM_MEDIUM)

                end

            end


            // =============================================
            // RN1
            // =============================================

            else begin


                // -------------------------
                // RN1 WRITE
                // -------------------------

                if (vif.cpu1_write_valid) begin

                    tr = my_chi_transaction::type_id::create("tr");
                  tr.is_rn0 = is_rn0 ? 1'b1 : 1'b0;

                    tr.is_write   = 1'b1;
                    tr.addr       = vif.cpu1_write_addr;
                    tr.write_data = vif.cpu1_write_data;

                    `uvm_info("RN1_MONITOR",
                        $sformatf(
                            "WRITE REQUEST ADDR=%h DATA=%h",
                            tr.addr,
                            tr.write_data),
                        UVM_MEDIUM)

                    mon_ap.write(tr);

                end


                // -------------------------
                // RN1 READ
                // -------------------------

                else if (vif.cpu1_read_valid) begin

                    pending_read = 1'b1;
                    pending_addr = vif.cpu1_read_addr;

                    `uvm_info("RN1_MONITOR",
                        $sformatf(
                            "READ REQUEST ADDR=%h",
                            pending_addr),
                        UVM_MEDIUM)

                end

            end


        end

    endtask



     =====
    // RESPONSE MONITOR
     =====

    task monitor_response();

        my_chi_transaction tr;

        forever begin

            @(posedge vif.clk);


            // =============================================
            // RN0 RESPONSE
            // =============================================

            if (is_rn0) begin

                if (vif.resp0_valid && pending_read) begin

                    tr = my_chi_transaction::type_id::create("tr");
                  tr.is_rn0 = is_rn0 ? 1'b1 : 1'b0;

                    tr.is_write  = 1'b0;

                    tr.addr      = pending_addr;

                    tr.resp_valid = 1'b1;

                    tr.resp_data = vif.resp0_data;


                    `uvm_info("RN0_MONITOR",
                        $sformatf(
                            "READ RESPONSE ADDR=%h DATA=%h",
                            tr.addr,
                            tr.resp_data),
                        UVM_MEDIUM)


                    mon_ap.write(tr);

                    pending_read = 1'b0;

                end

            end


            // =============================================
            // RN1 RESPONSE
            // =============================================

            else begin

                if (vif.resp1_valid && pending_read) begin

                    tr = my_chi_transaction::type_id::create("tr");
                  tr.is_rn0 = is_rn0 ? 1'b1 : 1'b0;

                    tr.is_write  = 1'b0;

                    tr.addr      = pending_addr;

                    tr.resp_valid = 1'b1;

                    tr.resp_data = vif.resp1_data;


                    `uvm_info("RN1_MONITOR",
                        $sformatf(
                            "READ RESPONSE ADDR=%h DATA=%h",
                            tr.addr,
                            tr.resp_data),
                        UVM_MEDIUM)


                    mon_ap.write(tr);

                    pending_read = 1'b0;

                end

            end

        end

    endtask


endclass
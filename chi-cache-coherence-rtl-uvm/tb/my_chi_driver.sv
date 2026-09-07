class my_chi_driver extends uvm_driver #(my_chi_transaction);

   `uvm_component_utils(my_chi_driver)

   virtual my_chi_if vif;

   my_chi_transaction tr;
   bit is_rn0;

   function new(string name="my_chi_driver",
                uvm_component parent=null);
      super.new(name,parent);
   endfunction


   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      if(!uvm_config_db#(virtual my_chi_if)::get(this,"","vif",vif))
         `uvm_fatal(get_type_name(),"Virtual Interface Not Found")

        if (!uvm_config_db#(bit)::get(this, "", "is_rn0", is_rn0))
            `uvm_fatal(get_type_name(),
                       "is_rn0 configuration not found")

   endfunction


task run_phase(uvm_phase phase);

    my_chi_transaction tr;

    // Wait until DUT comes out of reset
    wait(vif.resetn === 1'b1);

    `uvm_info("DRIVER",
              "RESET RELEASED - DRIVER STARTING",
              UVM_MEDIUM)

    forever begin

        seq_item_port.get_next_item(tr);

        drive_request(tr);

        wait_for_completion(tr);

        seq_item_port.item_done();

    end

endtask

task drive_request(my_chi_transaction tr);

    if (is_rn0) begin

        if (tr.is_write) begin

            @(posedge vif.clk);
            #1;

            vif.cpu0_write_addr  = tr.addr;
            vif.cpu0_write_data  = tr.write_data;
            vif.cpu0_write_valid = 1'b1;

            `uvm_info("DRIVER",
                      $sformatf("RN0 WRITE DRIVE: ADDR=%h DATA=%h",
                                tr.addr, tr.write_data),
                      UVM_MEDIUM)

            @(posedge vif.clk);
            #1;

            vif.cpu0_write_valid = 1'b0;
        end

        else begin

            @(posedge vif.clk);
            #1;

            vif.cpu0_read_addr  = tr.addr;
            vif.cpu0_read_valid = 1'b1;

            `uvm_info("DRIVER",
                      $sformatf("RN0 READ DRIVE: ADDR=%h",
                                tr.addr),
                      UVM_MEDIUM)

            @(posedge vif.clk);
            #1;

            vif.cpu0_read_valid = 1'b0;
        end

    end

    else begin

        if (tr.is_write) begin

            @(posedge vif.clk);
            #1;

            vif.cpu1_write_addr  = tr.addr;
            vif.cpu1_write_data  = tr.write_data;
            vif.cpu1_write_valid = 1'b1;

            @(posedge vif.clk);
            #1;

            vif.cpu1_write_valid = 1'b0;
        end

        else begin

            @(posedge vif.clk);
            #1;

            vif.cpu1_read_addr  = tr.addr;
            vif.cpu1_read_valid = 1'b1;

            @(posedge vif.clk);
            #1;

            vif.cpu1_read_valid = 1'b0;
        end

    end

endtask

task wait_for_completion(my_chi_transaction tr);

    // WRITE transaction
    if(tr.is_write) begin

        `uvm_info("DRIVER",
                  "WRITE COMPLETED",
                  UVM_MEDIUM)

        // No response expected from DUT
        return;

    end

    // READ transaction
    if(is_rn0) begin

        `uvm_info("DRIVER",
                  "RN0 WAITING FOR RESPONSE",
                  UVM_MEDIUM)

        do @(posedge vif.clk);
        while(!vif.resp0_valid);
      @(posedge vif.clk);
      
        `uvm_info("DRIVER",
                  $sformatf("RN0 RESPONSE RECEIVED DATA=%h",
                            vif.resp0_data),
                  UVM_MEDIUM)

        tr.resp_valid = 1'b1;
        tr.resp_data  = vif.resp0_data;
    end
    else begin

        `uvm_info("DRIVER",
                  "RN1 WAITING FOR RESPONSE",
                  UVM_MEDIUM)

        do @(posedge vif.clk);
        while(!vif.resp1_valid);
         @(posedge vif.clk);

        `uvm_info("DRIVER",
                  $sformatf("RN1 RESPONSE RECEIVED DATA=%h",
                            vif.resp1_data),
                  UVM_MEDIUM)

        tr.resp_valid = 1'b1;
        tr.resp_data  = vif.resp1_data;
    end

endtask


endclass
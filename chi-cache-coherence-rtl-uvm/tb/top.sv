module top;

    logic clk;
    logic resetn;

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end
    initial begin
        resetn = 1'b0;

        #20;

        resetn = 1'b1;
    end
    my_chi_if vif (
        .clk    (clk),
        .resetn (resetn)
    );
    my_chi dut (

        .clk    (clk),
        .resetn (resetn),

        .cpu0_read_valid  (vif.cpu0_read_valid),
        .cpu0_read_addr   (vif.cpu0_read_addr),

        .cpu0_write_valid (vif.cpu0_write_valid),
        .cpu0_write_addr  (vif.cpu0_write_addr),
        .cpu0_write_data  (vif.cpu0_write_data),

        .cpu1_read_valid  (vif.cpu1_read_valid),
        .cpu1_read_addr   (vif.cpu1_read_addr),

        .cpu1_write_valid (vif.cpu1_write_valid),
        .cpu1_write_addr  (vif.cpu1_write_addr),
        .cpu1_write_data  (vif.cpu1_write_data),
      
      .resp0_valid      (vif.resp0_valid),
        .resp0_data       (vif.resp0_data),

        .resp1_valid      (vif.resp1_valid),
        .resp1_data       (vif.resp1_data)

    );
  
initial begin
    vif.cpu0_read_valid  = 0;
    vif.cpu0_write_valid = 0;
    vif.cpu1_read_valid  = 0;
    vif.cpu1_write_valid = 0;

    vif.cpu0_read_addr   = 0;
    vif.cpu0_write_addr  = 0;
    vif.cpu0_write_data  = 0;

    vif.cpu1_read_addr   = 0;
    vif.cpu1_write_addr  = 0;
    vif.cpu1_write_data  = 0;
end
  
  task init_memory();
    for (int i = 0; i < 1024; i++)
        dut.mem[i] = 32'h0;

    dut.mem['h100 >> 2] = 32'h33333333;
    dut.mem['h200 >> 2] = 32'h5555AAAA;
    dut.mem['h300 >> 2] = 32'h44444444;
endtask

    initial begin

        uvm_config_db#(virtual my_chi_if)::set(
            null,
            "*",
            "vif",
            vif
        );
    init_memory();
      run_test();

    end
  

endmodule
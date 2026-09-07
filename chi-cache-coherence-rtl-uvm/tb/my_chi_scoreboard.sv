`uvm_analysis_imp_decl(_mon)

class my_chi_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(my_chi_scoreboard)

    uvm_analysis_imp_mon #(my_chi_transaction,
                           my_chi_scoreboard) analysis_export;

    bit [31:0] ref_mem [0:1023];

    bit [31:0] expected;
  
  int read_hits;
  int read_misses;
  int snoop_hits;
  int memory_reads;
  int memory_writes;
  
  bit rn0_has_data [0:1023];
  bit rn1_has_data [0:1023];
    real hit_rate;


    function new(string name = "my_chi_scoreboard",
                 uvm_component parent = null);

        super.new(name, parent);

        analysis_export = new("analysis_export", this);
      chi_cgp=new();
    endfunction
  
  
my_chi_transaction tr;

covergroup chi_cgp;

    // RN0 / RN1
    CP_RN : coverpoint tr.is_rn0 {
        bins RN0 = {0};
        bins RN1 = {1};
    }

    // READ / WRITE
    CP_OP : coverpoint tr.is_write {
        bins READ  = {0};
        bins WRITE = {1};
    }

    // Response
    CP_RESP : coverpoint tr.resp_valid {
        bins VALID   = {1};
        bins INVALID = {0};
    }

    // Address
    CP_ADDR : coverpoint tr.addr {
        bins ADDR_0_255     = {[0:255]};
        bins ADDR_256_511   = {[256:511]};
        bins ADDR_512_1023  = {[512:1023]};
    }

    // Write data
    CP_WDATA : coverpoint tr.write_data {
        bins ZERO = {32'h00000000};
        bins A    = {32'hAAAAAAAA};
        bins B    = {32'hBBBBBBBB};
    }

    // RN × operation
    RN_OPERATION : cross CP_RN, CP_OP;

endgroup


    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        foreach(ref_mem[i])
            ref_mem[i] = '0;
      
          foreach (rn0_has_data[i])
        rn0_has_data[i] = 1'b0;

    foreach (rn1_has_data[i])
        rn1_has_data[i] = 1'b0;

    read_hits    = 0;
    read_misses  = 0;
    snoop_hits   = 0;
    memory_reads = 0;
    memory_writes = 0;
      
    endfunction


virtual function void write_mon(my_chi_transaction t);

    int index;
  tr=t;

    index = tr.addr[11:2];

     
    // WRITE
     

    if (tr.is_write) begin

        // Every write updates main memory
        memory_writes++;

        // Update reference memory
        ref_mem[index] = tr.write_data;

        // Update ownership
        if (tr.is_rn0 == 1) begin
            rn0_has_data[index] = 1'b1;
            rn1_has_data[index] = 1'b0;
        end
        else begin
            rn1_has_data[index] = 1'b1;
            rn0_has_data[index] = 1'b0;
        end

        `uvm_info("SCOREBOARD",
            $sformatf("WRITE: MEM[%h] = %h",
                      tr.addr,
                      tr.write_data),
            UVM_LOW)
    end

     
    // READ
     

    else if (tr.resp_valid) begin

        if (tr.is_rn0 == 1) begin

            // RN1 owns the line -> SNOOP HIT
            if (rn1_has_data[index]) begin

                read_hits++;
                snoop_hits++;

            end

            // No other cache owns it -> MEMORY READ
            else begin

                read_misses++;
                memory_reads++;

            end

            // RN0 now has the data
            rn0_has_data[index] = 1'b1;

        end

        else begin

            // RN0 owns the line -> SNOOP HIT
            if (rn0_has_data[index]) begin

                read_hits++;
                snoop_hits++;

            end

            // No other cache owns it -> MEMORY READ
            else begin

                read_misses++;
                memory_reads++;

            end

            // RN1 now has the data
            rn1_has_data[index] = 1'b1;

        end

         
        // DATA CHECK
         

        expected = ref_mem[index];

        if (tr.resp_data == expected) begin

            `uvm_info("SCOREBOARD",
                $sformatf("READ PASS: ADDR=%h EXPECTED=%h ACTUAL=%h",
                          tr.addr,
                          expected,
                          tr.resp_data),
                UVM_LOW)

        end

        else begin

            `uvm_error("SCOREBOARD",
                $sformatf("READ FAIL: ADDR=%h EXPECTED=%h ACTUAL=%h",
                          tr.addr,
                          expected,
                          tr.resp_data))
        end

    end

     
    // FUNCTIONAL COVERAGE
     

    chi_cgp.sample();

endfunction
  
function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  


    super.report_phase(phase);

    if ((read_hits + read_misses) != 0)
        hit_rate = (real'(read_hits) /
                   real'(read_hits + read_misses)) * 100.0;
    else
        hit_rate = 0.0;

    `uvm_info("CHI_STATS",
        "==========================================",
        UVM_NONE)

    `uvm_info("CHI_STATS",
        "          CHI STATISTICS",
        UVM_NONE)

    `uvm_info("CHI_STATS",
        $sformatf("Read Hits      : %0d", read_hits),
        UVM_NONE)

    `uvm_info("CHI_STATS",
        $sformatf("Read Misses    : %0d", read_misses),
        UVM_NONE)

    `uvm_info("CHI_STATS",
        $sformatf("Snoop Hits     : %0d", snoop_hits),
        UVM_NONE)

    `uvm_info("CHI_STATS",
        $sformatf("Memory Reads   : %0d", memory_reads),
        UVM_NONE)

    `uvm_info("CHI_STATS",
        $sformatf("Memory Writes  : %0d", memory_writes),
        UVM_NONE)

    `uvm_info("CHI_STATS",
        $sformatf("Hit Rate       : %.1f%%", hit_rate),
        UVM_NONE)

    `uvm_info("CHI_STATS",
        "==========================================",
        UVM_NONE)

    `uvm_info("COV_REPORT",
        $sformatf("Overall Coverage = %.2f%%",
                  chi_cgp.get_coverage()),
        UVM_NONE)

    `uvm_info("COV_REPORT",
        $sformatf("RN Coverage      = %.2f%%",
                  chi_cgp.CP_RN.get_coverage()),
        UVM_NONE)

    `uvm_info("COV_REPORT",
        $sformatf("Operation        = %.2f%%",
                  chi_cgp.CP_OP.get_coverage()),
        UVM_NONE)

    `uvm_info("COV_REPORT",
        $sformatf("Response         = %.2f%%",
                  chi_cgp.CP_RESP.get_coverage()),
        UVM_NONE)

    `uvm_info("COV_REPORT",
        $sformatf("Address          = %.2f%%",
                  chi_cgp.CP_ADDR.get_coverage()),
        UVM_NONE)

    `uvm_info("COV_REPORT",
        $sformatf("Write Data       = %.2f%%",
                  chi_cgp.CP_WDATA.get_coverage()),
        UVM_NONE)

endfunction

endclass
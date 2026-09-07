parameter int MEM_LATENCY = 1;
module my_chi(
  input logic clk, 
  input logic resetn,
      // Request from CPU
   input logic        cpu0_read_valid,
  input logic [31:0] cpu0_read_addr,

   input logic        cpu0_write_valid,
  input logic [31:0] cpu0_write_addr,
  input logic [31:0] cpu0_write_data,
  
      // Request from CPU1
   input  logic        cpu1_read_valid,
  input logic [31:0] cpu1_read_addr,

   input logic        cpu1_write_valid,
  input logic [31:0] cpu1_write_addr,
  input logic [31:0] cpu1_write_data,
  
      output logic resp0_valid,
    output logic [31:0] resp0_data,

    output logic resp1_valid,
    output logic [31:0] resp1_data

);


  logic [3:0] mem_wait_cnt;
  
     logic        write0_valid;
     logic [31:0] write0_addr;
     logic [31:0] write0_data;

    // Request to HN
     logic        req0_valid;
     logic [31:0] req0_addr;
     //logic resp0_valid;
     //logic [31:0] resp0_data;

     logic        write1_valid;
     logic [31:0] write1_addr;
     logic [31:0] write1_data;

    // Request to HN
     logic        req1_valid;
     logic [31:0] req1_addr;
     //logic resp1_valid;
    // logic [31:0] resp1_data;


    // Snoop request from HN
       logic        snoop0_valid;
       logic [31:0] snoop0_addr;

    // Snoop response to HN
      logic        snoop0_hit;
      logic [31:0] snoop0_data;
      logic        snoop0_resp_valid;

    // Snoop request from HN
       logic        snoop1_valid;
       logic [31:0] snoop1_addr;

    // Snoop response to HN
      logic        snoop1_hit;
      logic [31:0] snoop1_data;
      logic        snoop1_resp_valid;

    // READ from HN
       logic        read_valid;
       logic [31:0] read_addr;

      logic        read_resp_valid;
      logic [31:0] read_data;

    // WRITE from HN
       logic        mem_write_valid;
       logic [31:0] mem_write_addr;
       logic [31:0] mem_write_data;


    typedef struct packed {
    logic        valid;
    logic        is_write;
    logic        cpu_id;      // 0=RN0, 1=RN1
    logic [31:0] addr;
    logic [31:0] data;
} req_t;
  req_t req_fifo[2];

logic fifo_wr_ptr;
logic fifo_rd_ptr;

logic [1:0] fifo_count;
  
  logic fifo_empty;
logic fifo_full;

assign fifo_empty = (fifo_count == 2'd0);
assign fifo_full  = (fifo_count == 2'd2);
  
    
// Request FIFO control
  

logic fifo_pop;

  
      
    // Cache
      

    logic [31:0] cache0_data  [0:255];
    logic [21:0] cache0_tag   [0:255];
    logic        cache0_valid [0:255];
  
    logic        cache0_fill_valid;
    logic [31:0] cache0_fill_addr;
    logic [31:0] cache0_fill_data;

      
    // Address fields
      

  logic [7:0]  index0;
    logic [21:0]  tag0;

    assign  index0 =  snoop0_addr[9:2];
    assign  tag0   =  snoop0_addr[31:10];

      
    // Snoop operation
      

    always_ff @(posedge  clk or negedge  resetn) begin
        integer i;
        if (! resetn) begin
         req0_valid <= 1'b0;
         req0_addr  <= 32'b0;

         write0_valid <= 1'b0;
         write0_addr  <= 32'b0;
         write0_data  <= 32'b0;

             snoop0_hit        <= 1'b0;
             snoop0_data       <= 32'b0;
             snoop0_resp_valid <= 1'b0;
       
            for (i = 0; i < 256; i = i + 1) begin
              cache0_valid[i] <= 1'b0;
            end

        end

        else begin
          
          if (cache0_fill_valid) begin

    cache0_valid[cache0_fill_addr[9:2]] <= 1'b1;

    cache0_tag[cache0_fill_addr[9:2]]
        <= cache0_fill_addr[31:10];

    cache0_data[  cache0_fill_addr[9:2]]
        <= cache0_fill_data;

end

            // Default values
             snoop0_resp_valid <= 1'b0;
             snoop0_hit        <= 1'b0;
             snoop0_data       <= 32'b0;

         req0_valid <= 1'b0;
         write0_valid <= 1'b0;


        // WRITE
        if (cpu0_write_valid) begin
          
              write0_valid <= 1'b1;
              write0_addr  <= cpu0_write_addr;
              write0_data  <= cpu0_write_data;

        end


        // Send request
       else if (cpu0_read_valid) begin
             req0_valid <= 1'b1;
             req0_addr  <= cpu0_read_addr;
        end

        // Receive response from HN
        if ( resp0_valid) begin

        end

            // Snoop request received
            if ( snoop0_valid) begin

                 snoop0_resp_valid <= 1'b1;

                // Check VALID + TAG
                if (cache0_valid[ index0] &&
                    cache0_tag[ index0] ==  tag0) begin

                    // CACHE HIT
                     snoop0_hit  <= 1'b1;
                     snoop0_data <= cache0_data[ index0];

                end

                else begin

                    // CACHE MISS
                     snoop0_hit  <= 1'b0;
                     snoop0_data <= 32'b0;

                end
            end
        end
    end


      
    // Cache
      

    logic [31:0] cache1_data  [0:255];
    logic [21:0] cache1_tag   [0:255];
    logic        cache1_valid [0:255];
  
    logic        cache1_fill_valid;
    logic [31:0] cache1_fill_addr;
    logic [31:0] cache1_fill_data;

      
    // Address fields
      

    logic [7:0]   index1;
    logic [21:0]  tag1;

    assign  index1 =  snoop1_addr[9:2];
    assign  tag1   =  snoop1_addr[31:10];

      
    // Snoop operation
      

    always_ff @(posedge  clk or negedge  resetn) begin
        integer i;
        if (! resetn) begin
         req1_valid <= 1'b0;
         req1_addr  <= 32'b0;

         write1_valid <= 1'b0;
         write1_addr  <= 32'b0;
         write1_data  <= 32'b0;

             snoop1_hit        <= 1'b0;
             snoop1_data       <= 32'b0;
             snoop1_resp_valid <= 1'b0;
       
            for (i = 0; i < 256; i = i + 1) begin
              cache1_valid[i] <= 1'b0;
            end

        end

        else begin
          
          if (cache1_fill_valid) begin

    cache1_valid[cache1_fill_addr[9:2]] <= 1'b1;

    cache1_tag[cache1_fill_addr[9:2]]
        <= cache1_fill_addr[31:10];

    cache1_data[cache1_fill_addr[9:2]]
        <= cache1_fill_data;

end

            // Default values
             snoop1_resp_valid <= 1'b0;
             snoop1_hit        <= 1'b0;
             snoop1_data       <= 32'b0;

         req1_valid <= 1'b0;
         write1_valid <= 1'b0;


        // WRITE
        if (cpu1_write_valid) begin
              write1_valid <= 1'b1;
              write1_addr  <= cpu1_write_addr;
              write1_data  <= cpu1_write_data;
        end


        // Send request
       else if (cpu1_read_valid) begin
             req1_valid <= 1'b1;
             req1_addr  <= cpu1_read_addr;
        end

        // Receive response from HN
        if ( resp1_valid) begin

        end

            // Snoop request received
            if ( snoop1_valid) begin

                 snoop1_resp_valid <= 1'b1;

                // Check VALID + TAG
                if (cache1_valid[ index1] &&
                    cache1_tag[ index1] ==  tag1) begin

                    // CACHE HIT
                     snoop1_hit  <= 1'b1;
                     snoop1_data <= cache1_data[ index1];

                end

                else begin

                    // CACHE MISS
                     snoop1_hit  <= 1'b0;
                     snoop1_data <= 32'b0;

                end
            end
        end
    end
  

// 2-Entry Request FIFO

logic enq0;
logic enq1;

assign enq0 = write0_valid || req0_valid;
assign enq1 = write1_valid || req1_valid;


always_ff @(posedge clk or negedge resetn) begin

    if (!resetn) begin

        req_fifo[0] <= '0;
        req_fifo[1] <= '0;

        fifo_wr_ptr <= 1'b0;
        fifo_rd_ptr <= 1'b0;

        fifo_count <= 2'd0;

    end

    else begin

        // ENQUEUE

        case ({enq1, enq0})

            // No request

            2'b00: begin
            end

            // RN0 request

            2'b01: begin

                if (!fifo_full) begin

                    req_fifo[fifo_wr_ptr].valid   <= 1'b1;
                    req_fifo[fifo_wr_ptr].is_write <= write0_valid;
                    req_fifo[fifo_wr_ptr].cpu_id  <= 1'b0;

                    if (write0_valid) begin
                        req_fifo[fifo_wr_ptr].addr <= write0_addr;
                        req_fifo[fifo_wr_ptr].data <= write0_data;
                    end
                    else begin
                        req_fifo[fifo_wr_ptr].addr <= req0_addr;
                        req_fifo[fifo_wr_ptr].data <= 32'b0;
                    end

                    fifo_wr_ptr <= fifo_wr_ptr + 1'b1;

                end

            end

            // RN1 request

            2'b10: begin

                if (!fifo_full) begin

                    req_fifo[fifo_wr_ptr].valid   <= 1'b1;
                    req_fifo[fifo_wr_ptr].is_write <= write1_valid;
                    req_fifo[fifo_wr_ptr].cpu_id  <= 1'b1;

                    if (write1_valid) begin
                        req_fifo[fifo_wr_ptr].addr <= write1_addr;
                        req_fifo[fifo_wr_ptr].data <= write1_data;
                    end
                    else begin
                        req_fifo[fifo_wr_ptr].addr <= req1_addr;
                        req_fifo[fifo_wr_ptr].data <= 32'b0;
                    end

                    fifo_wr_ptr <= fifo_wr_ptr + 1'b1;

                end

            end

            // RN0 + RN1 requests in same cycle

            2'b11: begin

                if (fifo_count == 0) begin

                    // RN0 -> FIFO[0]
                    req_fifo[fifo_wr_ptr].valid    <= 1'b1;
                    req_fifo[fifo_wr_ptr].is_write <= write0_valid;
                    req_fifo[fifo_wr_ptr].cpu_id   <= 1'b0;

                    if (write0_valid) begin
                        req_fifo[fifo_wr_ptr].addr <= write0_addr;
                        req_fifo[fifo_wr_ptr].data <= write0_data;
                    end
                    else begin
                        req_fifo[fifo_wr_ptr].addr <= req0_addr;
                        req_fifo[fifo_wr_ptr].data <= 32'b0;
                    end


                    // RN1 -> next FIFO entry
                    req_fifo[fifo_wr_ptr + 1'b1].valid    <= 1'b1;
                    req_fifo[fifo_wr_ptr + 1'b1].is_write <= write1_valid;
                    req_fifo[fifo_wr_ptr + 1'b1].cpu_id   <= 1'b1;

                    if (write1_valid) begin
                        req_fifo[fifo_wr_ptr + 1'b1].addr <= write1_addr;
                        req_fifo[fifo_wr_ptr + 1'b1].data <= write1_data;
                    end
                    else begin
                        req_fifo[fifo_wr_ptr + 1'b1].addr <= req1_addr;
                        req_fifo[fifo_wr_ptr + 1'b1].data <= 32'b0;
                    end

                    fifo_wr_ptr <= fifo_wr_ptr +2;

                end

                else if (fifo_count == 1) begin

                    // Only one free entry.
                    // RN0 gets priority.

                    req_fifo[fifo_wr_ptr].valid    <= 1'b1;
                    req_fifo[fifo_wr_ptr].is_write <= write0_valid;
                    req_fifo[fifo_wr_ptr].cpu_id   <= 1'b0;

                    if (write0_valid) begin
                        req_fifo[fifo_wr_ptr].addr <= write0_addr;
                        req_fifo[fifo_wr_ptr].data <= write0_data;
                    end
                    else begin
                        req_fifo[fifo_wr_ptr].addr <= req0_addr;
                        req_fifo[fifo_wr_ptr].data <= 32'b0;
                    end

                    fifo_wr_ptr <= fifo_wr_ptr + 1'b1;

                end

            end

        endcase

        // DEQUEUE

        if (fifo_pop) begin

            req_fifo[fifo_rd_ptr].valid <= 1'b0;

            fifo_rd_ptr <= fifo_rd_ptr + 1'b1;

        end

        // FIFO COUNT

        case ({fifo_pop, enq1, enq0})

            // No enqueue, no dequeue
            3'b000:
                fifo_count <= fifo_count;


            // RN0 enqueue
            3'b001:
                if (!fifo_full)
                    fifo_count <= fifo_count + 1'b1;


            // RN1 enqueue
            3'b010:
                if (!fifo_full)
                    fifo_count <= fifo_count + 1'b1;


            // RN0 + RN1 enqueue
            3'b011:
                if (fifo_count == 0)
                    fifo_count <= 2;
                else if (fifo_count == 1)
                    fifo_count <= 2;


            // Dequeue only
            3'b100:
                  if (!fifo_empty)
                    fifo_count <= fifo_count - 1'b1;


            // Dequeue + RN0
            3'b101:
                fifo_count <= fifo_count;


            // Dequeue + RN1
            3'b110:
                fifo_count <= fifo_count;


            // Dequeue + RN0 + RN1
            3'b111:
                if (fifo_count == 0)
                    fifo_count <= 2;
                else if (fifo_count == 1)
                    fifo_count <= 2;
                else
                    fifo_count <= fifo_count;

        endcase

    end
end
  


       logic [31:0] saved_addr; //temp_addr
  logic [31:0] saved_write_data;
       logic request_from_rn1;  //req_id
  logic [7:0]  saved_index;
  logic [21:0] saved_tag;

  assign saved_index = saved_addr[9:2];
  assign saved_tag   = saved_addr[31:10];

    // Directory

    logic rn0_has_data [0:255];
    logic rn1_has_data [0:255];

    // HN FSM

  typedef enum logic [3:0] {
        IDLE,
        CHECK_DIR,
        SNOOP_RN0,
        SNOOP_RN1,
        WAIT_SNOOP0,
        WAIT_SNOOP1,
        READ_MEM,
        WAIT_MEMORY,
        WRITE_MEM
    } state_t;

    state_t state;


    logic [7:0] req_index;

    assign req_index = saved_addr[9:2];


    integer i;

    always_ff @(posedge  clk or negedge  resetn) begin

        if (! resetn) begin

            state <= IDLE;
             mem_wait_cnt <= 0;

             resp0_valid <= 1'b0;
             resp0_data  <= 32'b0;

             snoop0_valid <= 1'b0;
             snoop0_addr  <= 32'b0;

             resp1_valid <= 1'b0;
             resp1_data  <= 32'b0;

             snoop1_valid <= 1'b0;
             snoop1_addr  <= 32'b0;

             mem_write_valid <= 1'b0;
             read_valid <= 1'b0;
             read_addr  <= 32'b0;
          
             cache0_fill_valid <= 1'b0;
             cache1_fill_valid <= 1'b0;

             cache0_fill_addr  <= 32'b0;
             cache0_fill_data  <= 32'b0;

             cache1_fill_addr  <= 32'b0;
             cache1_fill_data  <= 32'b0;

            for (i = 0; i < 256; i = i + 1) begin
                rn0_has_data[i] <= 1'b0;
                rn1_has_data[i] <= 1'b0;
            end

        end

        else begin

     
            // Default pulse signals
     

             resp0_valid  <= 1'b0;
             resp1_valid  <= 1'b0;
             mem_write_valid <= 1'b0;
             read_valid  <= 1'b0;
             snoop0_valid <= 1'b0;
             snoop1_valid <= 1'b0;
             cache0_fill_valid <= 1'b0;
             cache1_fill_valid <= 1'b0;
             fifo_pop <= 1'b0;

            case (state)

                 
                // IDLE
                 

                IDLE: begin

      if (!fifo_empty) begin

 
        // Take request from FIFO
 

        saved_addr       <= req_fifo[fifo_rd_ptr].addr;
        saved_write_data <= req_fifo[fifo_rd_ptr].data;

        request_from_rn1 <= req_fifo[fifo_rd_ptr].cpu_id;
        
        fifo_pop <= 1'b1;


 
        // Decide WRITE or READ
 

        if (req_fifo[fifo_rd_ptr].is_write) begin

            state <= WRITE_MEM;

        end
        else begin

            state <= CHECK_DIR;

        end

    end

                end

                 
                // CHECK DIRECTORY
                 

                CHECK_DIR: begin

    if (request_from_rn1 == 1'b0) begin

        // RN0 requested.
        // Check whether RN1 has the line.

        if (rn1_has_data[req_index]) begin

            state <= SNOOP_RN1;

        end

        else begin

            state <= READ_MEM;

        end

    end

    else begin

        // RN1 requested.
        // Check whether RN0 has the line.

        if (rn0_has_data[req_index]) begin

            state <= SNOOP_RN0;

        end

        else begin

            state <= READ_MEM;

        end

    end

end

                // SEND SNOOP0

                SNOOP_RN0: begin

                     snoop0_valid <= 1'b1;
                     snoop0_addr  <= saved_addr;

                    state <= WAIT_SNOOP0;
                end

                // SEND SNOOP1

                SNOOP_RN1: begin

                     snoop1_valid <= 1'b1;
                     snoop1_addr  <= saved_addr;

                    state <= WAIT_SNOOP1;

                end

                // WAIT FOR RN0

                WAIT_SNOOP0: begin

                    if ( snoop0_resp_valid) begin

                        if ( snoop0_hit) begin


                            // Send data to RN0
                             resp1_valid <= 1'b1;
                             resp1_data  <=  snoop0_data;

                            // Both RN0 and RN1 have a copy
                            rn0_has_data[req_index] <= 1'b1;
                            rn1_has_data[req_index] <= 1'b1;
                            state <= IDLE;


                        end

                        else begin


                            state <= READ_MEM;

                        end
                    end

                end


                 
                // WAIT FOR RN1
                 

                WAIT_SNOOP1: begin

                    if ( snoop1_resp_valid) begin

                        if ( snoop1_hit) begin

                            // Send data to RN0
                             resp0_valid <= 1'b1;
                             resp0_data  <=  snoop1_data;

                            // Both RN0 and RN1 have a copy
                            rn0_has_data[req_index] <= 1'b1;
                            rn1_has_data[req_index] <= 1'b1;
                            state <= IDLE;

                        end

                        else begin


                            state <= READ_MEM;

                        end
                    end

                end

              READ_MEM: begin

    read_valid <= 1'b0;

    if (mem_wait_cnt == MEM_LATENCY-1) begin

        read_valid   <= 1'b1;
        read_addr    <= saved_addr;

        mem_wait_cnt <= 0;
        state        <= WAIT_MEMORY;

    end
    else begin

        mem_wait_cnt <= mem_wait_cnt + 1;

    end

end

// WAIT FOR MEMORY
                 

WAIT_MEMORY: begin

    if (read_resp_valid) begin

        if (request_from_rn1) begin

            // Response to RN1
            resp1_valid <= 1'b1;
            resp1_data  <= read_data;

            // Tell RN1 to fill its cache
            cache1_fill_valid <= 1'b1;
            cache1_fill_addr  <= saved_addr;
            cache1_fill_data  <= read_data;

            // Directory
            rn1_has_data[req_index] <= 1'b1;


        end

        else begin

            // Response to RN0
            resp0_valid <= 1'b1;
            resp0_data  <= read_data;

            // Tell RN0 to fill its cache
            cache0_fill_valid <= 1'b1;
            cache0_fill_addr  <= saved_addr;
            cache0_fill_data  <= read_data;

            // Directory
            rn0_has_data[req_index] <= 1'b1;


        end

        state <= IDLE;

    end

end



 WRITE_MEM: begin

    mem_write_valid <= 1'b1;
    mem_write_addr  <= saved_addr;
    mem_write_data  <= saved_write_data;

    if (request_from_rn1) begin

        // Update directory
        rn1_has_data[req_index] <= 1'b1;
        rn0_has_data[req_index] <= 1'b0;
      
        // Invalidate RN0 cache line
      // cache0_valid[req_index] <= 1'b0;

        // Fill RN1 cache with written data
        cache1_fill_valid <= 1'b1;
        cache1_fill_addr  <= saved_addr;
        cache1_fill_data  <= saved_write_data;



    end
    else begin

        // Update directory
        rn0_has_data[req_index] <= 1'b1;
        rn1_has_data[req_index] <= 1'b0;
        
        // Invalidate RN1 cache line
       // cache1_valid[req_index] <= 1'b0;

        // Fill RN0 cache with written data
        cache0_fill_valid <= 1'b1;
        cache0_fill_addr  <= saved_addr;
        cache0_fill_data  <= saved_write_data;


    end

    state <= IDLE;

end
            endcase

        end

    end


  logic [31:0] mem [0:1023];

    logic [9:0] read_index;
    logic [9:0] write_index;

    assign read_index  =  read_addr[11:2];
    assign write_index =  mem_write_addr[11:2];

    always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        read_resp_valid <= 1'b0;
        read_data <= 32'b0;
      
      foreach (mem[i])
            mem[i] <= 32'b0;
    end
    else begin
        read_resp_valid <= 1'b0;

        if (mem_write_valid) begin

            mem[write_index] <= mem_write_data;
        end

        if (read_valid) begin
            read_resp_valid <= 1'b1;
            read_data <= mem[read_index];
        end
    end
end

endmodule
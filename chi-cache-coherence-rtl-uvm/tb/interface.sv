interface my_chi_if(

input logic clk,
input logic resetn);

// RN0 request
logic        cpu0_read_valid;
logic [31:0] cpu0_read_addr;
logic        cpu0_write_valid;
logic [31:0] cpu0_write_addr;
logic [31:0] cpu0_write_data;

// RN1 request
logic        cpu1_read_valid;
logic [31:0] cpu1_read_addr;
logic        cpu1_write_valid;
logic [31:0] cpu1_write_addr;
logic [31:0] cpu1_write_data;

// Responses
logic        cpu0_response_valid;
logic [31:0] cpu0_response_data;

logic        cpu1_response_valid;
logic [31:0] cpu1_response_data;
  
logic resp0_valid;
  logic [31:0] resp0_data;

logic resp1_valid;
  logic [31:0] resp1_data;

endinterface
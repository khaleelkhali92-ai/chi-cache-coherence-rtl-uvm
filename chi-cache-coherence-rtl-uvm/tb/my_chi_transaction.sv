class my_chi_transaction extends uvm_sequence_item;

    `uvm_object_utils(my_chi_transaction)


    bit        is_rn0;       
    rand bit        is_write;     // 0 = READ, 1 = WRITE

    rand bit [31:0] addr;
    rand bit [31:0] write_data;


    bit        resp_valid;
    bit [31:0] resp_data;


    function new(string name = "my_chi_transaction");
        super.new(name);
    endfunction

    function void do_print(uvm_printer printer);

        super.do_print(printer);

        printer.print_field_int("is_write",
                                is_write,
                                1,
                                UVM_DEC);

        printer.print_field_int("addr",
                                addr,
                                32,
                                UVM_HEX);

        printer.print_field_int("write_data",
                                write_data,
                                32,
                                UVM_HEX);

        printer.print_field_int("resp_valid",
                                resp_valid,
                                1,
                                UVM_DEC);

        printer.print_field_int("resp_data",
                                resp_data,
                                32,
                                UVM_HEX);

    endfunction

endclass
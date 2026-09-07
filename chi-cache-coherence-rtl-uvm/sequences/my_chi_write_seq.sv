class my_chi_write_seq extends my_chi_base_seq;

    `uvm_object_utils(my_chi_write_seq)
      bit [31:0] seq_addr;
    bit [31:0] seq_data;

    function new(string name="my_chi_write_seq");
        super.new(name);
    endfunction

    virtual task body();

        my_chi_transaction tx;

        tx = my_chi_transaction::type_id::create("tx");

        start_item(tx);

      assert(tx.randomize() with
        {
            is_write == 1;
            addr       == seq_addr;
            write_data == seq_data;
            
        });

        finish_item(tx);

    endtask

endclass
class my_chi_read_seq extends my_chi_base_seq;

    `uvm_object_utils(my_chi_read_seq)

    function new(string name="my_chi_read_seq");
        super.new(name);
    endfunction

    virtual task body();

        my_chi_transaction tx;

        tx = my_chi_transaction::type_id::create("tx");

        start_item(tx);

        assert(tx.randomize() with
        {
            is_write == 0;
            addr == 32'h00000100;
        });

        finish_item(tx);

    endtask

endclass
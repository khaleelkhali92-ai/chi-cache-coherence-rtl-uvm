# CHI Cache Coherence RTL + UVM

A simplified ARM CHI-inspired cache coherent interconnect designed in SystemVerilog RTL and verified using a reusable UVM verification environment.

---

## Project Overview

This project implements a simplified cache coherent system consisting of:

- Home Node (HN)
- Two Request Nodes (RN0 and RN1)
- Shared Memory
- Private caches for each Request Node
- Directory-based ownership tracking
- Cache-to-cache data transfer
- Configurable memory latency
- Request FIFO for handling multiple requests

The verification environment is built using SystemVerilog UVM and supports constrained-random stimulus, self-checking scoreboard, and functional coverage.

---

## Features

### RTL

- Home Node (HN) finite state machine
- Two Request Nodes (RN0 & RN1)
- Directory-based cache ownership
- Cache hit detection
- Cache miss handling
- Cache-to-cache data forwarding
- Automatic cache fill after memory reads
- Memory write handling
- Configurable memory latency
- Request queue (basic request pipelining)

---

### UVM Verification

- Reusable transaction class
- Driver
- Monitor
- Sequencer
- Agent
- Environment
- Scoreboard
- Read/Write sequences
- Self-checking verification
- Functional coverage

---

## Architecture

<img width="657" height="487" alt="h2CEny9O3NAixLVfRFgeJi4rRHWPbkUaZuEALiU5bKH46FjQj54GDyKtTK8m4l3tXe0P49tbR8aq-3-nZ_zTEUAKoe8-E5wGTo2z4r1eoIEfLT7YSXcWT4cgndMIhcyN0hZ7vKKvQLU4jcWFzt38Zjz9GFzWGpj_1_uEA64vsFE" src="https://github.com/user-attachments/assets/af646afc-83f3-4d1f-9ed9-c2b9315f95cb" />


---

## Verification Scenarios

✔ RN0 WRITE → RN0 READ

✔ RN1 WRITE → RN1 READ

✔ RN0 WRITE → RN1 READ

✔ RN1 WRITE → RN0 READ

✔ RN0 READ → RN1 Cache Hit

✔ RN1 READ → RN0 Cache Hit

✔ Simultaneous RN0 & RN1 READ

✔ Simultaneous RN0 & RN1 WRITE

✔ Cache Fill after Memory Read

✔ Directory Ownership Update

✔ Configurable Memory Latency


---

## Tools Used

- SystemVerilog
- UVM 1.2
- Synopsys VCS
- Verdi

---

## Simulation Result

```
UVM_INFO testbench.sv(870) @ 2026: uvm_test_top.env.sb [CHI_STATS] ==========================================
UVM_INFO testbench.sv(874) @ 2026: uvm_test_top.env.sb [CHI_STATS]           CHI STATISTICS
UVM_INFO testbench.sv(878) @ 2026: uvm_test_top.env.sb [CHI_STATS] Read Hits      : 9
UVM_INFO testbench.sv(882) @ 2026: uvm_test_top.env.sb [CHI_STATS] Read Misses    : 1
UVM_INFO testbench.sv(886) @ 2026: uvm_test_top.env.sb [CHI_STATS] Snoop Hits     : 9
UVM_INFO testbench.sv(890) @ 2026: uvm_test_top.env.sb [CHI_STATS] Memory Reads   : 1
UVM_INFO testbench.sv(894) @ 2026: uvm_test_top.env.sb [CHI_STATS] Memory Writes  : 8
UVM_INFO testbench.sv(898) @ 2026: uvm_test_top.env.sb [CHI_STATS] Hit Rate       : 90.0%
UVM_INFO testbench.sv(902) @ 2026: uvm_test_top.env.sb [CHI_STATS] ==========================================
UVM_INFO testbench.sv(906) @ 2026: uvm_test_top.env.sb [COV_REPORT] Overall Coverage = 100.00%
UVM_INFO testbench.sv(911) @ 2026: uvm_test_top.env.sb [COV_REPORT] RN Coverage      = 100.00%
UVM_INFO testbench.sv(916) @ 2026: uvm_test_top.env.sb [COV_REPORT] Operation        = 100.00%
UVM_INFO testbench.sv(921) @ 2026: uvm_test_top.env.sb [COV_REPORT] Response         = 100.00%
UVM_INFO testbench.sv(926) @ 2026: uvm_test_top.env.sb [COV_REPORT] Address          = 100.00%
UVM_INFO testbench.sv(931) @ 2026: uvm_test_top.env.sb [COV_REPORT] Write Data       = 100.00%
```

<img width="1648" height="958" alt="8c2794fd-1309-4a16-a536-be4097846cab" src="https://github.com/user-attachments/assets/91f3532d-59bd-4b2c-b192-c3d03815a36f" />


<img width="1881" height="958" alt="b58758a1-c9b2-4e4f-8db6-e6191a57248d" src="https://github.com/user-attachments/assets/32a8f0f4-bde0-4839-81e6-d2333752422b" />




---

## Future Enhancements

- MESI/MOESI protocol support
- Cache line invalidation
- Multiple outstanding transactions
- Additional CHI protocol channels
- SystemVerilog Assertions (SVA)

---

## Author

E Khaleel

B.Tech Electronics & Communication Engineering

Interested in RTL Design, Design Verification, Computer Architecture and Cache Coherence.

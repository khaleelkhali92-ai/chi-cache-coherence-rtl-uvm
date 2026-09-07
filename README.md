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

```
<img width="657" height="487" alt="h2CEny9O3NAixLVfRFgeJi4rRHWPbkUaZuEALiU5bKH46FjQj54GDyKtTK8m4l3tXe0P49tbR8aq-3-nZ_zTEUAKoe8-E5wGTo2z4r1eoIEfLT7YSXcWT4cgndMIhcyN0hZ7vKKvQLU4jcWFzt38Zjz9GFzWGpj_1_uEA64vsFE" src="https://github.com/user-attachments/assets/4155c28b-f02c-4d98-ac41-1f355385a9e9" />

```

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

## Directory Structure

```
RTL/
    my_chi.sv
    memory.sv
    ...

UVM/
    interface.sv
    transaction.sv
    sequence.sv
    sequencer.sv
    driver.sv
    monitor.sv
    scoreboard.sv
    agent.sv
    env.sv
    test.sv

sim/

README.md
```

---

## Tools Used

- SystemVerilog
- UVM 1.2
- Synopsys VCS
- Verdi

---

## Simulation Result

```
PASS COUNT = 8
FAIL COUNT = 0

******** ALL TESTS PASSED ********
```

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

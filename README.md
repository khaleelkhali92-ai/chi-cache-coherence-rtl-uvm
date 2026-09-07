# CHI Cache Coherence RTL + UVM

A simplified ARM CHI-inspired cache coherent interconnect designed in SystemVerilog RTL and verified using a reusable UVM verification environment.


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

# Cache Controller
The first project in Digital Systems Engineering (COE758)

## Project Overview

This project involves the design, implementation, and simulation of a simplified cache controller intended to operate within a memory hierarchy. The controller sits between a hypothetical CPU and an SDRAM main memory, managing a local SRAM-based cache (BlockRAM). Its primary function is to improve memory access times by storing frequently used data closer to the CPU, handling cache hits/misses, and managing data consistency using valid and dirty bits.

The implemented cache is a direct-mapped cache with a total capacity of 256 bytes, organized into 8 blocks, with each block containing 32 bytes (words).

## Objectives

*   To understand the functionality of a cache controller and its interaction with block-memory (SRAM) and SDRAM controllers.
*   To gain practical experience in designing and implementing custom logic controllers using VHDL.
*   To learn interfacing techniques with SRAM memory units and other logic devices.
*   To practice VHDL coding within the Xilinx ISE CAD environment.
*   To simulate and evaluate the hardware implementation on a Xilinx Spartan-3E FPGA platform.

## Design Details

The cache controller manages interactions based on CPU requests (address, read/write signal, data) and the current state of the cache blocks (tag, index, valid bit, dirty bit).

### Key Features:
*   **Direct-Mapped Cache:** Uses index bits from the CPU address to map to a specific cache line.
*   **Hit/Miss Detection:** Compares the tag portion of the CPU address with the stored tag for the corresponding index, checking the valid bit.
*   **Read/Write Operations:**
    *   **Read Hit:** Data is retrieved directly from the local cache SRAM.
    *   **Write Hit:** Data is written to the local cache SRAM, and the dirty bit is set.
*   **Miss Handling (Write-Back Policy):**
    *   **Miss (Dirty Bit = 0):** Fetches the required block from SDRAM into the cache SRAM, updates the tag and valid bit, then performs the original CPU request.
    *   **Miss (Dirty Bit = 1):** Writes the *existing* dirty block back to SDRAM, *then* fetches the *new* required block from SDRAM into the cache SRAM, updates tag and valid bit, and finally performs the original CPU request.
*   **Finite State Machine (FSM):** The controller's logic is implemented using a state machine to manage the different operational phases (Idle, Check Hit/Miss, Read from Cache, Write to Cache, Write Back to SDRAM, Fetch from SDRAM).
*   **Interfaces:** Designed to interact with specific CPU, SDRAM Controller, and BlockRAM (Cache SRAM) interfaces as defined in the project specifications.

## State Diagram
![image](https://github.com/user-attachments/assets/686e5ff2-47f9-4c0e-871e-8f4e87d19716)

## States
**State 0 - IDLE**
- The idle state, just waiting for the CPU to select 1
- When it receives 1, then it moves to the dispatcher state

**State 1 - Dispatcher**
- Depends on the CPU requests then it moves to that state
- These are the following states below:
  - Read hit
  - Write hit
  - Miss d-bit = 0
  - Miss d-bit = 1
- Note: There is no "Read Miss" or "Write Miss" state because, in case of a cache miss, block replacement is performed first, followed by the required action from the CPU
- The transition to a specific state depends on the conditions provided by the CPU

**State 2 - Read Hit**
- In this state, the data requested to read is in the cache, so you just retrieve whatever was in the cache (BRAM) and then send it out to the appropriate signal
- Returns to the idle state

**State 3 - Write Hit**
- In this state, the tag exists in the cache and now you write to the cache and set the d-bit to 1
- Returns to the idle state

**State 4 - Write Cache to Main**
- The d-bit = 1, the cache contains modified data that needs to be written back to main memory
  - Propagate the changes from the cache to main memory
- Go to State 5, once done

**State 5 - Write Main to Cache**
- The tag was not in the cache and the d-bit = 0, simply perform block replacement
- Go back to State 2 (Dispatcher) and perform actions specified by CPU

## Performance Results (from Simulation)

The following performance parameters were measured via functional simulation using Xilinx ISE tools:

| Parameter                             | Time (ns) |
| :------------------------------------ | :-------- |
| Hit / Miss determination time         | 10        |
| Data access time (Cache SRAM R/W)     | 20        |
| Block replacement time (SDRAM access) | 650       |
| **Hit time (Case 1 & 2)**             | **30.5**  |
| **Miss penalty (Case 3, D-bit = 0)**  | **705**   |
| **Miss penalty (Case 4, D-bit = 1)**  | **1352**  |

*Note: The Hit/Miss determination time is limited by the 10ns sampling rate (half clock cycle) of the system simulation clock (20ns period).*

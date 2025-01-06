# Cache Controller
The first project in Digital Systems Engineering (COE758)

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

## Specification

## Functions

## Things to note

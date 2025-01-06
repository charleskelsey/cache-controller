# Cache Controller
The first project in Digital Systems Engineering (COE758)

## State Diagram
![image](https://github.com/user-attachments/assets/686e5ff2-47f9-4c0e-871e-8f4e87d19716)

## States
State 0 - IDLE
- The idle state, you are just waiting for the CPU to assert chip select to 1
- Once it receives chip signal assertion then it moves to the dispatcher state

State 1 - Dispatcher
- Depending on what the CPU wants to do you go to the corresponding state, which are the following states below
  - Read hit
  - Write hit
  - Miss d-bit = 0
  - Miss d-bit = 1
- You may be wondering why there's not read miss, or write miss that's because you have to do block replacement when its a miss for either then perform the action required by the CPU
- So again depending some conditions you go into that state

State 2 - Read Hit
- If you get to this state, that means that the data requested to read is in the cache, so you just retrieve whatever was in the cache (BRAM) and then send it out onto the appropriate signal
- Return to idle state

State 3 - Write Hit
- If you get to this state, that means that the tag exists in the cache and now you write to the cache and set the d-bit to 1
- Return to idle state

State 4 - Write Main to Cache
- The tag was not in cache and the d-bit = 0, so you can simply perform block replacement
- Go back to State 2 (Dispatcher) and perform actions specified by CPU

State 5 - Write Cache to Main
- The d-bit = 1, meaning that cache has been written into and therefore you need to propagate those changes to Main Memory
- Go to State 4, once you're done

## Specification

## Functions

## Things to note

# FPGA Implementation of Radix-2 Booth Multiplier Using Datapath and Control Path

## Overview
This project implements a parameterized Radix-2 Booth Multiplier in Verilog using a modular datapath and control path based design. The multiplier was functionally verified through simulation and implemented on FPGA. The parameterized design makes it scalable and reusable for different operand widths.

## Folder Structure
- `src/` : FPGA implementation source code
- `simulation/` : simulation source code and testbench
- `constraints/` : XDC pin constraint file
- `docs/` : flowchart and architecture diagrams
- `results/` : simulation, FPGA output, timing, utilization, and power analysis results

## Tools Used
- Verilog HDL
- Xilinx Vivado
- Basys-3 FPGA Board

## Features
- Parameterized Radix-2 Booth multiplication
- Datapath and control path based architecture
- Functional simulation using testbench
- FPGA hardware implementation
- Scalable design for different bit widths
- Timing, power, and resource analysis

## Limitations
- For an N-bit 2’s complement system, the range is −2^(N−1) to 2^(N−1) − 1  
- The most negative value (−2^(N−1)) cannot be represented as a positive number  
- Example: In 4-bit, −8 cannot be converted to +8 (max is +7)  
- This may lead to incorrect results for such edge-case multiplications

## Author
Aswanth Gopal  
B.Tech, Electronics and Communication Engineering  
National Institute of Technology Calicut
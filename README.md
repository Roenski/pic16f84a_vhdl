# PIC16F84A microcontroller in VHDL
## Overview
This project implements most of the functionalities of a PIC16F84A microcontroller in VHDL. Included is also the test bench, which shows all the functionality, as well as a tcl-file for generating a Vivado-project. The project contains only the code, i.e. it has not been synthesized or physically implemented on real hardware. 
## Features 
List of features implemented:
* Decoder
* ALU
* RAM
* Work, FSR and STATUS register functionalities
* Program counter, instruction register

Some features **not** implemented include:
* Stack -> no branch operations
* Timers
* EEPROM
* Program memory
## Demo
Inside simulations-folder, there is a file called `led_blinker_noloop.asm`. That code contains some demo code, and comments about what different registers are supposed to do on different commands. There is also the corresponding hex-file called `Led-blinker.hex`, which is used by the testbench `tb_top.vhd`.
## How to run
Easiest way to run is to use Vivado. Navigate into Vivado-folder (located inside this repository), and run the build.tcl with Vivado. There is a batch-file for Windows, which works if the path is correct (probably not, so check it). Same goes for the source script (build.src), which can be used on Linux with the command `source build.src`. Once the Vivado-project opens, you can simply click "Run simulation".

There is also a .do file (sim_top.do), which can be used with ModelSim with the command `vsim -do sim_top.do`.

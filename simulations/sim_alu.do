vlib work
vcom -2008 -work work ../vhdl/cpu_types.vhd
vcom -2008 -work work ../vhdl/ALU.vhd
vcom -2008 -work work ../vhdl/tb_ALU.vhd

vsim work.tb_alu
add wave op1
add wave op2
add wave st_in
add wave bs
add wave op_func
add wave res
add wave st
run -all
wave zoom full

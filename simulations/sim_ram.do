vlib work
vcom -2008 -work work ../vhdl/cpu_types.vhd
vcom -2008 -work work ../vhdl/RAM.vhd
vcom -2008 -work work ../vhdl/tb_RAM.vhd

vsim work.tb_RAM
add wave addr_bus
add wave data_bus
add wave read_bus
add wave reset
add wave clk
add wave pc_out
add wave st_in
add wave st_out
add wave re
add wave we
run -all
wave zoom full

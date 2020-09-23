vlib work
vcom -2008 -work work ../vhdl/cpu_types.vhd
vcom -2008 -work work ../vhdl/ALU.vhd
vcom -2008 -work work ../vhdl/RAM.vhd
vcom -2008 -work work ../vhdl/decoder.vhd
vcom -2008 -work work ../vhdl/top.vhd
vcom -2008 -work work ../piklab/hexfile_reader.vhd
vcom -2008 -work work ../vhdl/tb_top.vhd


vsim work.tb_top
add wave clk
add wave reset
add wave RA
add wave RB
add wave -label cur_state sim/:tb_top:top:cur_state
add wave -label operation sim/:tb_top:top:operation
add wave -label W -unsigned sim/:tb_top:top:W
add wave -label STATUS -unsigned sim/:tb_top:top:RAM:mem_block(3)
add wave -label USER1 -unsigned sim/:tb_top:top:RAM:mem_block(12)
add wave -label USER2 -unsigned sim/:tb_top:top:RAM:mem_block(13)
run -all
wave zoom full


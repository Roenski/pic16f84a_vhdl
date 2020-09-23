# Set the reference directory to where the script is
set origin_dir [file dirname [info script]]
set vhdl_dir $origin_dir/../vhdl
set sim_dir $origin_dir/../simulations

# Project name
set project_name "pic16f84a"

# Creates project files
create_project $project_name $origin_dir/$project_name

# Add the source files
add_files -norecurse $vhdl_dir/cpu_types.vhd 
add_files -norecurse $vhdl_dir/ALU.vhd 
add_files -norecurse $vhdl_dir/decoder.vhd 
add_files -norecurse $vhdl_dir/RAM.vhd 
add_files -norecurse $vhdl_dir/top.vhd
update_compile_order -fileset sources_1

# Add the simulation files
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse $vhdl_dir/tb_top.vhd 
add_files -fileset sim_1 -norecurse $vhdl_dir/hexfile_reader.vhd

# Hex file that contains the code
add_files -fileset sim_1 -norecurse $sim_dir/Led-blinker.hex

# Wave view file
add_files -fileset sim_1 -norecurse $sim_dir/tb_top_behav.wcfg

update_compile_order -fileset sources_1
#############################################################################################
#############################################################################################
#
#   The MIT License (MIT)
#   
#   Copyright (c) 2023 http://odelay.io 
#   
#   Permission is hereby granted, free of charge, to any person obtaining a copy
#   of this software and associated documentation files (the "Software"), to deal
#   in the Software without restriction, including without limitation the rights
#   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#   copies of the Software, and to permit persons to whom the Software is
#   furnished to do so, subject to the following conditions:
#   
#   The above copyright notice and this permission notice shall be included in all
#   copies or substantial portions of the Software.
#   
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#   SOFTWARE.
#   
#   Contact : <everett@odelay.io>
#  
#   Description : Build script for the Fixed AXI Stream design targetted to KR260 board 
#
#   Version History:
#   
#       Date        Description
#     -----------   -----------------------------------------------------------------------
#      2023-04-18    Original Creation
#
###########################################################################################


set overlay_name "kr260_hls_fixed_gain_stream"
set design_name "kr260_hls_fixed_gain_stream"

# Create Project
set_param board.repoPaths {/home/sdr/kr260-workspace/XilinxBoardStore}
create_project kr260_hls_fixed_gain_stream kr260_hls_fixed_gain_stream -part xck26-sfvc784-2LV-c
set_property BOARD_PART xilinx.com:kr260_som:part0:1.0 [current_project]
set_property target_language VHDL [current_project]
set_property default_lib work [current_project]


# Adding Library to project
set_property  ip_repo_paths  ../lib [current_project]
update_ip_catalog

# Add VHDL File(s)
add_files -norecurse ../lib/led_reg/hw/led_reg.vhd

# source the board design
source ./kr260_hls_fixed_gain_stream_bd.tcl


# open block design
#open_project ./${overlay_name}/${overlay_name}.xpr
open_bd_design ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/${design_name}/${design_name}.bd

# Add top wrapper and xdc files
make_wrapper -files [get_files ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/${design_name}/${design_name}.bd] -top
add_files -norecurse ./${overlay_name}/${overlay_name}.gen/sources_1/bd/${design_name}/hdl/${design_name}_wrapper.vhd
set_property top ${design_name}_wrapper [current_fileset]

# Add XDC File(s)
import_files -fileset constrs_1 -norecurse ./leds_pinout.xdc



update_compile_order -fileset sources_1

# call implement
# I'm cheap and don't have a computer with enough memory, so only use 1-CPU :(
launch_runs impl_1 -to_step write_bitstream -jobs 1
wait_on_run impl_1

# This hardware definition file will be used for microblaze projects
write_hw_platform -fixed -include_bit -force -file ./${overlay_name}.xsa
validate_hw_platform ./${overlay_name}.xsa

# copy and rename bitstream to final location
exec mkdir output
file copy -force ./${overlay_name}/${overlay_name}.runs/impl_1/${design_name}_wrapper.bit ./output/${overlay_name}.bit
file copy -force ./${overlay_name}/${overlay_name}.gen/sources_1/bd/${design_name}/hw_handoff/${design_name}.hwh ./output/${overlay_name}.hwh

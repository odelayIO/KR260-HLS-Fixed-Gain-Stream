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
#   Description : Makefile for Fixed AXI Stream design
#
#   Version History:
#   
#       Date        Description
#     -----------   -----------------------------------------------------------------------
#      2023-04-18    Original Creation
#
###########################################################################################




overlay_name := kr260_hls_fixed_gain_stream
design_name := kr260_hls_fixed_gain_stream

all: clean hls_ip build_design check_timing
	@echo
	@tput setaf 2 ; echo "Built $(overlay_name) successfully!"; tput sgr0;
	@echo

#source_vivado:
#	source /tools/Xilinx/Vivado/2019.1/settings64.sh

hls_ip:
	cd ./fpga/lib/fixed-gain-stream && vitis_hls -f run_hls.tcl && pwd

build_design:
	cd ./fpga/top && vivado -mode batch -source build_kr260_hls_fixed_gain_stream.tcl
	mv ./fpga/top/output . 

check_timing:
	cd ./fpga/top && vivado -mode batch -source check_$(overlay_name).tcl -notrace

#dsa:
#	vivado -mode batch -source build_$(overlay_name)_dsa.tcl -notrace

start_gui:
	vivado ./fpga/top/${design_name}/${overlay_name}.xpr

clean:
	rm -fr ./fpga/lib/fixed-gain-stream/proj_fixed_gain_stream
	rm -fr ./fpga/lib/fixed-gain-stream/*.log
	rm -fr ./fpga/lib/fixed-gain-stream/*.jou
	cd ./fpga/top && rm -rf $(overlay_name) *.jou *.log NA *.bit *.hwh *.xsa .Xil
	rm -fr *.log *.jou *.str .Xil
	rm -fr ./output

upload_all: upload_bit upload_regmaps

upload_bit:
	scp ./output/${overlay_name}.bit \
	./output/${overlay_name}.hwh \
	ubuntu@kria:/home/root/jupyter_notebooks/kr260_hls_fixed_gain_stream

upload_ipynb:
	scp ./host/py/${overlay_name}.ipynb \
	ubuntu@kria:/home/root/jupyter_notebooks/kr260_hls_fixed_gain_stream

upload_regmaps:
	scp ./fpga/lib/led_reg/sw/led_regmap.py \
	ubuntu@kria:/home/root/jupyter_notebooks/kr260_hls_fixed_gain_stream

get_remote_ipynb:
	scp ubuntu@kria:/home/root/jupyter_notebooks/kr260_hls_fixed_gain_stream/${overlay_name}.ipynb ./host/py/.

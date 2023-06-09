# KR260-HLS-Fixed-Gain-Stream
<p align="center">
  <img src="./doc/kriapynq.png">
</p>




## Overview

This design targets the [Xilinx Kria KR260 starter kit](https://www.xilinx.com/products/som/kria/kr260-robotics-starter-kit.html) with [Kria-PYNQ framework](https://github.com/Xilinx/Kria-PYNQ).  It implements a configurable AXI-Stream gain block using Vitis HLS.  In addition, this design utlizes [Corsair](https://github.com/odelayIO/corsair-reg-map/tree/b59d100e01f0f7f7dbdeb8154418169900fc06a0) AXI-Lite register generation.  Two modules use [Corsair](https://github.com/odelayIO/corsair-reg-map/tree/b59d100e01f0f7f7dbdeb8154418169900fc06a0) to control the 2 User LEDs and to read the FPGA time-stamp register (its a register that contains the time in which the FPGA was built). See the [Jupyter Notebook](https://github.com/odelayIO/KR260-HLS-Fixed-Gain-Stream/blob/main/host/py/kr260_hls_fixed_gain_stream.ipynb) in the repository.

The Makefile at the base of the repository has a help menu.  Just type `make help` to see a list of actions.  Corsair autogenerates documentation of the register map. 

[LED Module Register Map](https://github.com/odelayIO/KR260-HLS-Fixed-Gain-Stream/blob/main/fpga/lib/led_reg/doc/led_reg.md)

[Timestamp Register Map](https://github.com/odelayIO/KR260-HLS-Fixed-Gain-Stream/blob/main/fpga/lib/timestamp/doc/timestamp_reg.md)



## Getting Started

It is assumed you have built the [vivado2022.1_docker](https://github.com/odelayIO/vivado2022.1_docker) container on the host machine.  In addition, the KR260 board has the PYNQ framework install on board.  Please follow the directions on the [Xilinx Kria-PYNQ](https://github.com/Xilinx/Kria-PYNQ) for instructions to create the KR260 SD card image and install PYNQ framework on the KR260. 

```bash
git clone --recursive git@github.com:odelayIO/KR260-HLS-Fixed-Gain-Stream.git
```

Then run the Vivado 2022.1 Docker container, and make the FPGA image.  See Developer Notes below regarding Vivado SWAP issue that might cause systems to crash during the FPGA build process.

```bash
cd KR260-HLS-Fixed-Gain-Stream
make
```

Once the FPGA image is finished building, copy the bit stream, hardware definition file, and Jupyter Notebook.  Please note you will need to create a folder `kr260_hls_fixed_gain_stream` on the KR260 board.  This could be completed through the Jupyter interface.

```bash
make upload_all
```

Now you want to open a web browser and navigate to the KR260-PYNQ board.  

http://kria:9090/lab/tree/kr260_hls_fixed_gain_stream

The Jupyter Notebook for this project has additional information how to interact with the KR260. 

https://github.com/odelayIO/KR260-HLS-Fixed-Gain-Stream/blob/main/host/py/kr260_hls_fixed_gain_stream.ipynb







# Developer Notes

## ZYNQ PL Clocks

These are the clocked which are generated in the ZYNQ, and provided to the PL.  The design operates at 100MHz.

| Clock Net Name | Frequency (MHz) |
| -------------- | --------------- |
| pl_clk0        | 99.999001MHz    |
| pl_clk1        | 299.997009MHz   |



## Corsair AXI-Lite File Register Generation

This project utilizes Corsair to generate the AXI-Lite file register to generate the `led_reg` module.  



## Add Submodule to repository

```
git submodule add https://github.com/odelayIO/corsair-reg-map/ corsair-reg-map
cd corsair-reg-map/
git checkout v0.1
cd ..
git add .gitmodules corsair-reg-map
```



## Increase System Swap Memory

Vivado requests a lot of memory to build FPGAs.  In my case the Vivado build crashed when I set the CPU job to 8 cores.  I have 2GB swap, which I want to increase to 12GB

```
swapon --show
sudo sudo swapoff -a
sudo dd if=/dev/zero of=/swapfile bs=1M count=16384
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo free -h
```



## Set timezone on KR260 board

```bash
sudo timedatectl set-timezone America/Los_Angeles
```



## Install `gtkwave`

This will be helpful to view the VCD trace dump from the HLS simulation.  This is installed in the [vivado2022.1_docker](https://github.com/odelayIO/vivado2022.1_docker).








# KR260-HLS-Fixed-Gain-Stream

TODO:

- [x] Update the Jupyter Notes Script
- [x] Verify the design on the KR260 hardware
- [ ] Document Project 



```bash
sudo timedatectl set-timezone America/Los_Angeles
```





## Install `gtkwave`

- This will be helpful to view the VCD trace dump from the HLS simulation





## ZYNQ PL Clocks

These are the clocked which are generated in the ZYNQ, and provided to the PL.

pl_clk0 = 99.999001MHz

pl_clk1 = 299.997009MHz



## Quick Start

```bash
git clone --recursive git@github.com:odelayIO/KR260-HLS-Fixed-Gain-Stream.git
```



## Installing Corsair

```bash
./run-vivado-2022p1.sh
su root
apt install python3-pip
pip3 install gitpython
python3 -m pip install -U corsair
```



## Run Corsair from Source

```bash
git clone git@github.com:odelayIO/corsair-reg-map.git /tools/corsair-reg-map
export PYTHONPATH := /tools/corsair-reg-map/.:$(PYTHONPATH)
pip3 install pyyaml
pip3 install Jinja2
pip3 install wavedrom 
```



## PYNQ MMIO Access

```python
import pynq
import Reg_Constants_Pkg as _REG

#	Contents of Reg_Constants_Pkg.py
#
#	BASE 		= 0x00_A000_0000
#	OFFSET		= 0xA000

pynq.mmio.MMIO(_REG.BASE + _REG.OFFSET)



import pynq

_BASE = 0x00_A002_0000
_LED_REG = 0x10 + _BASE

pynq.mmio.MMIO(_LED_REG).read()
```





```
from pynq import MMIO
       
mmio = MMIO(BASE_ADDRESS, ADDRESS_LENGTH)

for i in range(len(input_data)):
    mmio.write(OUTPUT_DATA_OFFSET + i * 4, input_data[i] + 1)

mmio.write(ACK_OFFSET, 1)
```



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


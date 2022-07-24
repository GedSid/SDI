#!/bin/bash

ghdl -a ../libs/par_scrambler.vhd
ghdl -a tb_par_scram.vhd
ghdl -e tb_par_scram
ghdl -r tb_par_scram --wave=wave.ghw --stop-time=10us
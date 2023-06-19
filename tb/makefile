
GHDL=ghdl
#FLAGS="--std=08"
FLAGS="-v"

all:
	@$(GHDL) -a $(FLAGS) tb_par_scram.vhd ../libs/par_scrambler.vhd
	@$(GHDL) -e $(FLAGS) tb_par_scram
	@$(GHDL) -r $(FLAGS) tb_par_scram --wave=wave.ghw --stop-time=1us
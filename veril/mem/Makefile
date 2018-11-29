GCC_OPT=-std=c99 -g
GCC=/usr/bin/gcc ${GCC_OPT}

# options: 
VERILATOR_OPT=-Wall --cc --trace --stats -sv
VERILATOR=/usr/bin/verilator ${VERILATOR_OPT}

comp: mem.sv mem_tb.cpp
	${VERILATOR} mem.sv --exe mem_tb.cpp; \
	make -j -C obj_dir/ -f Vmem.mk Vmem;

run: comp
	./obj_dir/Vmem

wave: 
	gtkwave mem.vcd mem.sav &

stest: 
	${GCC} -o stest stack_tst.c

clean: 
	rm -rf obj_dir mem.vcd stest


# Verilator options (-help)
# +1800-2012ext SystemVerilog 2012
# -cc		create C++ output
# --coverage	enable all coverate 
# --coverage-line
# --coverage-toggle
# --coverage-underscore   coverage of _signals
# //verilator coverage off/on  can be used to ignore signals for coverage
# --debug
# +define+<var>+<value>
# --exe  	link to create executable
# --gdb		run Verilator under GDB interactively
# -I<dir>	search dir for include files
# -o <name of executable>
# --stats	create statistics file
# -y <dir>	dir to search for modules
# -V		verbose
# -v <filename>	Verilog library

VERILATOR_OPT=-Wall --cc --trace 
VERILATOR=/usr/bin/verilator ${VERILATOR_OPT}
MODULE=counter

comp:
	${VERILATOR} ${MODULE}.v --exe ${MODULE}_tb.cpp; \
	make -j -C obj_dir/ -f V${MODULE}.mk V${MODULE};

run: 
	./obj_dir/V${MODULE}

wave: 
	gtkwave ${MODULE}.vcd ${MODULE}.sav &

clean:
	rm -rf obj_dir *.vcd


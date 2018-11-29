# Generate the project QSF file
#-------------------------------------------------------------------------------

set proj add_sub_top
#set proj [lindex $argv 0]
puts "Info: compiling project $proj"

set FAMILY "Stratix V"
set DEVICE 5SGXEA7N2F45C2ES

project_new $proj -overwrite
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY quartus_output
set_global_assignment -name FAMILY $FAMILY
set_global_assignment -name DEVICE $DEVICE
set_global_assignment -name TOP_LEVEL_ENTITY add_sub_top

set FILES "$proj.f"

if {[file exists $FILES] == 1} {
    set fd [open $FILES]
    while {[gets $fd line] >= 0} {
        if {[string last ".sv" $line] > 0} {
            set_global_assignment -name SYSTEMVERILOG_FILE $line
        } elseif {[string last ".v" $line] > 0} {
            set_global_assignment -name VERILOG_FILE $line
        }
    }
} elseif {[file exists "$proj.v"] == 1} {
    set_global_assignment -name VERILOG_FILE "$proj.v"
} elseif {[file exists "$proj.sv"] == 1} {
    set_global_assignment -name SYSTEMVERILOG_FILE "$proj.sv"
} else {
    puts "Error: no HDL files specified in proj.f, proj.v or proj.sv"
}

set sdc_file "$proj.sdc"
if {[file exists $sdc_file] == 1} {
    set_global_assignment -name SDC_FILE $sdc_file
} else {
    set_global_assignment -name SDC_FILE "clk200.sdc" 
}
set_global_assignment -name TIMEQUEST_MULTICORNER_ANALYSIS ON


#set_parameter -name WIDTH 4
set_global_assignment -name SEED 3

set_instance_assignment -name VIRTUAL_PIN ON -to a
set_instance_assignment -name VIRTUAL_PIN ON -to b
set_instance_assignment -name VIRTUAL_PIN ON -to ci
set_instance_assignment -name VIRTUAL_PIN ON -to sub
set_instance_assignment -name VIRTUAL_PIN ON -to co
set_instance_assignment -name VIRTUAL_PIN ON -to r

project_close

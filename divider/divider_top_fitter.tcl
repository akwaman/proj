# quartus_sh -t add_sub_fitter.tcl
project_open divider_top
load_package report
load_report
set aluts [get_fitter_resource_usage -alut]
set alms [get_fitter_resource_usage -alm]
set regs [get_fitter_resource_usage -reg]
set labs [get_fitter_resource_usage -lab]

puts "aluts $aluts"
puts "alms $alms"
puts "regs $regs"
puts "labs $labs"

unload_report
project_close

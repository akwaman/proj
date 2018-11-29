# quartus_sh -t fitter.tcl
project_open divider_top
load_package report
load_report
get_fitter_resource_usage -alut
get_fitter_resource_usage -alm
get_fitter_resource_usage -reg
get_fitter_resource_usage -lab


unload_report
project_close

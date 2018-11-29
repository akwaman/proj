
# helper for single destination
proc get_clock_from_port_name { port_id } {
	set port_name [get_node_info -name $port_id]
	foreach_in_collection clk_id [all_clocks] {
		set clk_targets [get_clock_info -targets $clk_id]
		foreach_in_collection target_id $clk_targets {
			set target_name [get_node_info -name $target_id]
			if { [string equal $target_name $port_name] } {
				return $clk_id
			}
		}
	}
}

# procedure for cases where there are no R2R - report to any register
proc report_single_destination { } {
	foreach_in_collection path_id [get_path -to [all_registers] -npaths 1] {
		set arrival_points [get_path_info -arrival_points $path_id]
		set add_flag 0
		set path_delay 0
		set dest_reg [get_path_info -to $path_id]
		set dest_reg_name [get_node_info -name $dest_reg]
		set clock_fanin [get_fanins -clock [get_registers $dest_reg_name]]
		
		set dest_clock [get_clock_from_port_name $clock_fanin]
		set dest_clock_period [get_clock_info -period $dest_clock]
		
		foreach_in_collection point_id $arrival_points {
			set point_type [get_point_info -type $point_id]
			set point_location [get_point_info -location $point_id]
			set incr_delay [get_point_info -incremental_delay $point_id]
			
			if { $add_flag } {
				set path_delay [expr { $path_delay + $incr_delay }]
			}

			if { [regexp {LAB} $point_location] } {
				set add_flag 1
			}
		}
		set slack [expr {$dest_clock_period - $path_delay}]
	}
	#post_message "$dest_reg_name $slack"
	puts "\{\"Look at me\",$slack ns, From (primary), To $dest_reg_name\}"
}
# main entry point
proc get_worst_failing_detail { args } {
	set min 999
	set min_domain ""

	# Get a setup summary report with some info on each domain
	set domain_list [get_clock_domain_info -setup]
	foreach domain $domain_list {
		# Each domain gives you its name, its slack, and two tns numbers
		foreach { name slack end_tns edge_tns } $domain { break }
		if { $slack < $min } {
			set min $slack
			set min_domain $name
		}
	}
	# if there are no good R2R fall back to anything to R	
	if { ! [info exists name] } { 
		report_single_destination 
		return 0 	
	}
	# When we get here, we have the min slack in $min and the associated
	# domain in $min_domain

	# Report setup on that domain
	set worst_case_path [get_timing_paths -to_clock $name -npaths 1 -setup]
	foreach_in_collection path_id $worst_case_path {
		# Get the source and destination of that one path, then break out
		# of the loop
		set src_reg_id [get_path_info -from $path_id]
		set dest_reg_id [get_path_info -to $path_id]
		set src_name [get_node_info -name $src_reg_id]
		set dest_name [get_node_info -name $dest_reg_id]
		break
	}
	# Print it
	puts "\{\"Look at me\",$min ns, From $src_name, To $dest_name\}"
}

get_worst_failing_detail
    
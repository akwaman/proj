onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /divider_tb/dut/dividend
add wave -noupdate -radix binary /divider_tb/dut/divisor
add wave -noupdate -radix binary /divider_tb/dut/error_divide_by_zero
add wave -noupdate /divider_tb/dut/overflow
add wave -noupdate -radix binary /divider_tb/dut/divisor_p1
add wave -noupdate /divider_tb/dut/partial_rem
add wave -noupdate -radix binary /divider_tb/dut/quotient
add wave -noupdate /divider_tb/dut/remainder
add wave -noupdate -divider {rollout 5}
add wave -noupdate /divider_tb/dut_1/partial_rem_p1
add wave -noupdate /divider_tb/dut_1/calc_p1
add wave -noupdate /divider_tb/dut_1/partial_rem_p2
add wave -noupdate /divider_tb/dut_1/calc_p2
add wave -noupdate /divider_tb/dut_1/partial_rem_p3
add wave -noupdate /divider_tb/dut_1/calc_p3
add wave -noupdate /divider_tb/dut_1/partial_rem_p4
add wave -noupdate /divider_tb/dut_1/calc_p4
add wave -noupdate /divider_tb/dut_1/partial_rem_p5
add wave -noupdate /divider_tb/dut_1/calc_p5
add wave -noupdate /divider_tb/dut_1/partial_rem_p6
add wave -noupdate /divider_tb/dut_1/calc_p6
add wave -noupdate /divider_tb/dut_1/error_divide_by_zero
add wave -noupdate /divider_tb/dut_1/overflow
add wave -noupdate /divider_tb/dut_1/remainder
add wave -noupdate /divider_tb/dut_1/quotient
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {151 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 247
configure wave -valuecolwidth 100
configure wave -justifyvalue right
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {11 ns}

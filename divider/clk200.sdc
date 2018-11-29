create_clock -name "clk" -period 5ns [get_ports {clk_ingress}]

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty

# tsu/th constraints
# tco constraints
# tpd constraints


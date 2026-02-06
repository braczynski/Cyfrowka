# ============================================================================ #
# Specify waves to be saved during the simulation
# ============================================================================ #
# Save top instance signals
log_wave *

# DUT instance signals
log_wave /fsm_test/dut/*

# All design signals (avoid using this in large designs - performance penalty!)
# log_wave -r *


# ============================================================================ #
# Run the simulation until $finish
# ============================================================================ #
run all


# ============================================================================ #
# Visualize the results
# ============================================================================ #

# ---------------------------------------------------------------------------- #
# Show all top instance signals (including local parameters)
# ---------------------------------------------------------------------------- #
# add_wave /

# ---------------------------------------------------------------------------- #
# Show all the design signals, recursive  
# Not very useful once your design grows!
# ---------------------------------------------------------------------------- #
# add_wave -r /

# ---------------------------------------------------------------------------- #
# Show selected top instance signals
# ---------------------------------------------------------------------------- #
add_wave_divider "TOP signals (fsm_test)"
add_wave /fsm_test/clk
add_wave /fsm_test/rst_n
add_wave /fsm_test/trigger
add_wave /fsm_test/done
add_wave /fsm_test/led
add_wave /fsm_test/en

# ---------------------------------------------------------------------------- #
# Show selected DUT instance signals
# ---------------------------------------------------------------------------- #
add_wave_divider "DUT signals (fsm dut instance)"
add_wave /fsm_test/dut/state_nxt -color gold
add_wave /fsm_test/dut/state
add_wave /fsm_test/dut/counter_nxt -color gold
add_wave /fsm_test/dut/counter

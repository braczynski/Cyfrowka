# ============================================================================ #
# Specify waves to be saved during the simulation
# ============================================================================ #
# Save top instance signals
log_wave *

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
add_wave_divider "TOP signals"
add_wave /vga_timing_test/clk
add_wave /vga_timing_test/rst_n
add_wave /vga_timing_test/hcount -radix unsigned -color aqua
add_wave /vga_timing_test/vcount -radix unsigned -color orange
add_wave /vga_timing_test/hsync -color aqua
add_wave /vga_timing_test/hblnk -color aqua
add_wave /vga_timing_test/vsync -color orange
add_wave /vga_timing_test/vblnk -color orange

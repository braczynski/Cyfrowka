# Vivado project configuration file

set project_name sseg_basys3
set top_module top_basys3
set target xc7a35tcpg236-1

set xdc_files {
    constraints/top_basys3.xdc
}

set sv_files {
    ../rtl/ring_counter.sv
    ../rtl/counter.sv
    ../rtl/sseg.sv
    ../rtl/sseg/hex2sseg.sv
    ../rtl/sseg/sseg_mux.sv
    ../rtl/top.sv
    rtl/top_basys3.sv
}

#!/usr/bin/env bash

if [[ -d xsim.dir ]]; then
    rm -rf xsim.dir
fi

xvlog -sv sim/cardooralarm_tb.sv rtl/CarDoorAlarm.sv 
xelab --debug typical cardooralarm_tb cardooralarm --snapshot top_sim
xsim -t xsim_run.tcl top_sim
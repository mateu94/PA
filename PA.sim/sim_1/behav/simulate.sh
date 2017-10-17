#!/bin/bash -f
xv_path="/home/marc/ompss/Vivado/2015.4"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim Registers_behav -key {Behavioral:sim_1:Functional:Registers} -tclbatch Registers.tcl -log simulate.log

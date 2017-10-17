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
ExecStep $xv_path/bin/xelab -wto deab1732696b47b9b389ba3420870c3c -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot Registers_behav xil_defaultlib.Registers xil_defaultlib.glbl -log elaborate.log

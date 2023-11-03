#!/bin/bash
# This shell script should be executed in directory work_dir/obsid/rgs.
# Extract RGS lightcurves.
# The 6th shell script.
# Author: Guan-Fu Liu
# Date: Feb. 20, 2023
# Use for loop to tidy up the shell scripts.
len=${#rgsid[@]}
for i in $(seq 1 $len)
do 
    lis_evt=P${obsid}R${rgsid[$i]}${expid[$i]}EVENLI0000.FIT
    lis_src=P${obsid}R${rgsid[$i]}${expid[$i]}SRCLI_0000.FIT
    evselect table=${lis_evt} timebinsize=${timebinsize} rateset=ltc_rgs${rgsid[$i]}_bkg.fits makeratecolumn=yes maketimecolumn=yes expression="(CCDNR==9)&&(REGION(${lis_src}:RGS${rgsid[$i]}_BACKGROUND,M_LAMBDA,XDSP_CORR))"
done

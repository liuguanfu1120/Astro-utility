#!/bin/bash
# This shell script should be executed in directory work_dir/targets/.../rgs.
# Extract RGS images.
# The 4th shell script.
# Author: Guan-Fu Liu
# Date: Sep. 18, 2023
# Use for loop to tidy up the shell scripts.

# The length of rgsid
len=${#rgsid[@]}
for i in $(seq 1 $len)
# Here i represents the RGS number.
do  
    lis_evt=P${obsid}R${rgsid[$i]}${expid[$i]}EVENLI0000.FIT
    evselect table=${lis_evt}:EVENTS imageset=img_rgs${rgsid[$i]}_xdsp_dsp.fits xcolumn='M_LAMBDA' ycolumn='XDSP_CORR'
    evselect table=${lis_evt}:EVENTS imageset=img_rgs${rgsid[$i]}_pi_dsp.fits xcolumn='M_LAMBDA' ycolumn='PI' imagebinning=imageSize ximagesize=${ximagesize} yimagesize=${yimagesize}
    lis_src=P${obsid}R${rgsid[$i]}${expid[$i]}SRCLI_0000.FIT
    cxctods9 table=${lis_src}:RGS${rgsid[$i]}_SRC${srcid}_SPATIAL regtype=linear -V 0 > A${obsid}R${rgsid[$i]}O${i}I${xpsfincl}E${xpsfexcl}S${nsigma}SRC.reg
done

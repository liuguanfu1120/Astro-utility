#!/bin/bash
# This shell script should be executed in directory work_dir/obsid/rgs.
# Extract RGS lightcurves.
# The 5th shell script.
# Author: Guan-Fu Liu
# Date: Sep. 18, 2023
# Tidy up the shell scripts.

rgslccorr evlist="P${obsid}R${rgsid[1]}${expid[1]}EVENLI0000.FIT P${obsid}R${rgsid[2]}${expid[2]}EVENLI0000.FIT" srclist="P${obsid}R${rgsid[1]}${expid[1]}SRCLI_0000.FIT P${obsid}R${rgsid[2]}${expid[2]}SRCLI_0000.FIT" timebinsize=${timebinsize} orders="1" sourceid=${srcid} outputsrcfilename=ltc_rgs_src.fits

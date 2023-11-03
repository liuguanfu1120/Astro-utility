#!/bin/bash
# This shell script should be executed in directory work_dir/obsid/rgs.
# Remove background flares by removing the rate larger than 4.049 (4.094 is chosen artificially).
# This method is not recommended.
# The 7th shell script.
# Option 1 for the 7th shell script, 2 options in total.
# Author: Guan-Fu Liu
# Date: Feb. 20, 2023

tabgtigen table=ltc_rgs_src.fits gtiset=gti1.fits timecolumn=TIME expression="(RATE<=4.049)"
rgsproc auxgtitables=gti1.fits entrystage=3:filter finalstage=5:fluxing witheffectiveareacorrection=yes withbackgroundmodel=yes

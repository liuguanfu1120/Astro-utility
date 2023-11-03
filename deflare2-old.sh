#!/bin/bash
# This shell script should be executed in directory work_dir/obsid/rgs.
# Remove background flares with sigma clipping method.
# This method is recommended.
# The 7th shell script.
# Option 2 for the 7th shell script, 2 options in total.
# Author: Guan-Fu Liu
# Date: Feb. 20, 2023

conda activate ciao-4.15
# deflare command is provided by CIAO
len=${#rgsid[@]}
for i in $(seq 1 $len)
do
    deflare infile=ltc_rgs${rgsid[$i]}_bkg.fits outfile=gti2R${rgsid[$i]}.fits method=sigma nsigma=${nsigma} plot=yes save=deflareR${rgsid[$i]}.png
done
conda deactivate
echo "Re-execute initialize.sh. \n"
echo "Please answer 'No' in the following two questions if you execute main.sh.\n"
# Move to work_dir/obsid/odf.
cd ../odf
# source initialize.sh
# Move back to work_dir/obsid/rgs.
cd ../rgs
for i in $(seq 1 $len)
do
    ftdelhdu infile="gti2R${rgsid[$i]}.fits[1]" outfile="gti2R${rgsid[$i]}.fits" clobber=yes
done
# ftdelhdu can also be used as follows.
# ftdelhdu infile="gti2R${rgsid[$i]}.fits[FILTER]" outfile="gti2R${rgsid[$i]}.fits" clobber=yes

echo "Choose one gti file to use. (1 or 2) \n"
while true
    do
        read i
        case $i in
            [1] ) 
                echo "Use gti2R${rgsid[$i]}.fits"
                break;;
            [2] ) 
                echo "Use gti2R${rgsid[$i]}.fits"
                break;;
            * ) 
                echo "Please choose 1 or 2.";;
        esac
    done
rgsproc auxgtitables=gti2R${rgsid[$i]}.fits entrystage=3:filter finalstage=5:fluxing witheffectiveareacorrection=yes withbackgroundmodel=yes

#!/bin/bash
# Copy FIT files of the same order from different observations
# For joint fitting.
# This shell script should be executed in work_dir/targets/$source_name.
# Author: Guan-Fu Liu
# Date: Sep. 18, 2023

cd $work_dir/targets/$source_name
# Set the destination directory
dest_dir=MRK1216-joint
if [ -d "$dest_dir" ]; then
    echo "Would you like to delete ${dest_dir}? (yes or no)"
    while true
    do``
        read yn
        case $yn in
            [Yy]* ) 
                echo "Delete ${dest_dir}!"
                rm -rf $dest_dir
                break;;
            [Nn]* ) 
                echo "Do not delete ${dest_dir}!"
                break;;
            * ) 
                echo "Please answer yes or no.";;
        esac
    done
else 
    echo "$dest_dir does not exist. It will be created."
    mkdir $dest_dir
fi

for order in $(seq 1 2)
do
    mkdir -p $dest_dir/order$order
    # rsync files to $dest_dir/order$order
    cd $work_dir/targets/$source_name/$dest_dir/order$order
    for i in $(seq 1 $len1)
    do
        obsid=${obsids[$i]}
        xpsfincl=${xpsfincls[$i]}
        xpsfexcl=${xpsfexcls[$i]}
        nsigma=${nsigmas[$i]}
        OBSPREFIX=A${obsid}R3O${order}I${xpsfincl}E${xpsfexcl}S${nsigma}
        cd $work_dir/targets/$source_name/${obsid}-${xpsfincl}-${xpsfexcl}-${nsigma}/rgs
        # Copy pha file, PHA is Pulse Height Analyser (uncalibrated spectral channel)
        cp ${OBSPREFIX}SRC.fits $work_dir/targets/$source_name/$dest_dir/order$order/${OBSPREFIX}SRC.fits
        # Copy rsp file, RMF is the redistribution matrix file.
        # Note that for RGS, the response matrix file (rmf) and ancillary response file (arf) 
        # are combined into one response file
        cp ${OBSPREFIX}.rsp $work_dir/targets/$source_name/$dest_dir/order$order/${OBSPREFIX}.rsp
        # Copy background file
        cp ${OBSPREFIX}BKG.fits $work_dir/targets/$source_name/$dest_dir/order$order/${OBSPREFIX}BKG.fits
    done
    cd $work_dir/targets/$source_name
done
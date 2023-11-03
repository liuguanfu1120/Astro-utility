#!/bin/bash
# Copy FIT files of the same order from different observations.
# For combined fitting.
# This shell script should be executed in work_dir/shell-scripts.
# Author: Guan-Fu Liu
# Date: Sep. 18, 2023

cd $work_dir/targets/$source_name
# Set the destination directory
dest_dir=MRK1216-combined
if [ -d "$dest_dir" ]; then
    echo "Would you like to delete ${dest_dir}? (yes or no)"
    while true
    do
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
    for i in $(seq 1 $len1)
    do
        obsid=${obsids[$i]}
        xpsfincl=${xpsfincls[$i]}
        xpsfexcl=${xpsfexcls[$i]}
        nsigma=${nsigmas[$i]}
        OBSPREFIX=A${obsid}R3O${order}I${xpsfincl}E${xpsfexcl}S${nsigma}
        cd $work_dir/targets/$source_name/${obsid}-${xpsfincl}-${xpsfexcl}-${nsigma}/rgs
        # pha file, PHA is Pulse Height Analyser (uncalibrated spectral channel)
        tr -s ' ' '\n' < ${OBSPREFIX}SRC.lis > ${OBSPREFIX}SRC.txt
        rsync -av --files-from=${OBSPREFIX}SRC.txt ./ $work_dir/targets/$source_name/$dest_dir/order$order/
        cat ${OBSPREFIX}SRC.txt >> $work_dir/targets/$source_name/$dest_dir/order$order/src-o${order}.txt
        # rsp file, the response file.
        # Note that for RGS, the response matrix file (rmf) and ancillary response file (arf) 
        # are combined into one response file.
        # The filenames in .lis file is separated by spaces.
        # However, for rsync, only one filename in one line is allowed.
        # tr will replace ' ' by '\n' (-s squeeze).
        tr -s ' ' '\n' < ${OBSPREFIX}RSP.lis > ${OBSPREFIX}RSP.txt
        rsync -av --files-from=${OBSPREFIX}RSP.txt ./ $work_dir/targets/$source_name/$dest_dir/order$order/
        cat ${OBSPREFIX}RSP.txt >> $work_dir/targets/$source_name/$dest_dir/order$order/rsp-o${order}.txt
        # background file
        tr -s ' ' '\n' < ${OBSPREFIX}BKG.lis > ${OBSPREFIX}BKG.txt
        rsync -av --files-from=${OBSPREFIX}BKG.txt ./ $work_dir/targets/$source_name/$dest_dir/order$order/
        cat ${OBSPREFIX}BKG.txt >> $work_dir/targets/$source_name/$dest_dir/order$order/bkg-o${order}.txt
    done
    OBSPREFIX=$source_name-combined-O${order}
    cd $work_dir/targets/$source_name/$dest_dir/order$order
    # For rgscombine, the pha, rmf, and bkg filenames can only be separated by spaces.
    rgscombine pha="$(tr -s '\n' ' ' < src-o${order}.txt)" rmf="$(tr -s '\n' ' ' < rsp-o${order}.txt)"     bkg="$(tr -s '\n' ' ' < bkg-o${order}.txt)" filepha=${OBSPREFIX}-SRC.fits filermf=${OBSPREFIX}.rsp filebkg=${OBSPREFIX}-BKG.fits
    # Include the background files via the keyword agrument "bkg"
    rgsfluxer pha="$(tr -s '\n' ' ' < src-o${order}.txt)" rmf="$(tr -s '\n' ' ' < rsp-o${order}.txt)"     bkg="$(tr -s '\n' ' ' < bkg-o${order}.txt)" file=${OBSPREFIX}-FLUX.fits
    cp $work_dir/shell-scripts/ChangeHeader.py ./
    conda deactivate
    conda activate spex
    python3 ChangeHeader.py
    ogip2spex --phafile ${OBSPREFIX}-SRC.fits --bkgfile ${OBSPREFIX}-BKG.fits --rmffile ${OBSPREFIX}.rsp --spofile ${OBSPREFIX}.spo --resfile ${OBSPREFIX}.res --overwrite
    cd $work_dir/targets/$source_name
done
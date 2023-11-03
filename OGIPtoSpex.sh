#!/bin/bash
# This shell script should be executed in directory work_dir/obsid/rgs.
# Author: Guan-Fu Liu
# Date: Sep. 18, 2023
# Run ChangeHeader.py first.
# Convert OGIP files to SPEX format.
conda deactivate
conda activate spex
python3 ChangeHeader.py
# A${obsid}R3O${i}I${xpsfincl}E${xpsfexcl}S${nsigma}:
# A: Analysis, R: RGS, 3=1+2=Combine RGS1 and RGS2
# O: Order, I: xpsfIncl, E: xpsfExcl, S: Sigma
# SRC: source, BKG: background, RSP: response, FLUX: fluxed spectrum

for i in $(seq 1 2)
# Here i represents the spectral order.
do 
    OBSPREFIX=A${obsid}R3O${i}I${xpsfincl}E${xpsfexcl}S${nsigma}
    ogip2spex --phafile ${OBSPREFIX}SRC.fits --bkgfile ${OBSPREFIX}BKG.fits --rmffile ${OBSPREFIX}.rsp --spofile ${OBSPREFIX}.spo --resfile ${OBSPREFIX}.res --overwrite
done
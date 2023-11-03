#!/bin/bash
# This shell script should be executed in directory work_dir/obsid/rgs.
# Combine RGS1 and RGS2 spectra of the same spectral order and generate fluxed spectra.
# The 8th shell script.
# Author: Guan-Fu Liu
# Date: Sep. 18, 2023
# Use for loop to tidy up the shell script.
# The filename convention is as follows.
# Write lists of files that contain  source (src.lis), response (rsp.lis) and background (bkg.lis).
# • P${obsid}R${rgsid}${expid}BGSPEC100${srcid}.FIT: 1st-order local background spectrum file
# • P${obsid}R${rgsid}${expid}BGSPEC200${srcid}.FIT: 2nd-order local background spectrum file
# • P${obsid}R${rgsid}${expid}MBSPEC1000.FIT: 1st-order model background spectrum
# • P${obsid}R${rgsid}${expid}MBSPEC2000.FIT: 2nd-order model background spectrum
# • P${obsid}R${rgsid}${expid}RSPMAT100${srcid}.FIT: 1st-order response file
# • P${obsid}R${rgsid}${expid}RSPMAT200${srcid}.FIT: 2nd-order response file
# • P${obsid}R${rgsid}${expid}SRSPEC100${srcid}.FIT: 1st-order source spectral file
# • P${obsid}R${rgsid}${expid}SRSPEC200${srcid}.FIT: 2nd-order source spectral file

# A${obsid}R3O${i}I${xpsfincl}E${xpsfexcl}S${nsigma}:
# A: Analysis, R: RGS, 3=1+2=Combine RGS1 and RGS2
# O: Order, I: xpsfIncl, E: xpsfExcl, S: Sigma
# SRC: source, BKG: background, RSP: response, FLUX: fluxed spectrum
for i in $(seq 1 2)
# Here i represents the spectral order.
do  
    OBSPREFIX=A${obsid}R3O${i}I${xpsfincl}E${xpsfexcl}S${nsigma}
    echo "P${obsid}R${rgsid[1]}${expid[1]}SRSPEC${i}00${srcid}.FIT P${obsid}R${rgsid[2]}${expid[2]}SRSPEC${i}00${srcid}.FIT" > ${OBSPREFIX}SRC.lis
    # src_o${i}.lis
    echo "P${obsid}R${rgsid[1]}${expid[1]}RSPMAT${i}00${srcid}.FIT P${obsid}R${rgsid[2]}${expid[2]}RSPMAT${i}00${srcid}.FIT" > ${OBSPREFIX}RSP.lis 
    # rsp_o${i}.lis
    echo "P${obsid}R${rgsid[1]}${expid[1]}MBSPEC${i}000.FIT P${obsid}R${rgsid[2]}${expid[2]}MBSPEC${i}000.FIT" >  ${OBSPREFIX}BKG.lis
    # bkg_o${i}.lis
    rgscombine pha="$(cat ${OBSPREFIX}SRC.lis)" rmf="$(cat ${OBSPREFIX}RSP.lis)" bkg="$(cat ${OBSPREFIX}BKG.lis)" filepha=${OBSPREFIX}SRC.fits filermf=${OBSPREFIX}.rsp filebkg=${OBSPREFIX}BKG.fits

# Include the background files via the keyword agrument "bkg"
    rgsfluxer pha="$(cat ${OBSPREFIX}SRC.lis)" rmf="$(cat ${OBSPREFIX}RSP.lis)" bkg="$(cat ${OBSPREFIX}BKG.lis)" file=${OBSPREFIX}FLUX.fits
done

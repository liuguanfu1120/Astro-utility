#!/bin/bash
# This shell script should be executed in directories work_dir and work_dir/obsid/odf.
# Input the Obs.ID, ra_deg and dec_deg of the source and some other paramters.
# The 0th shell script.
# Author: Guan-Fu Liu
# Date: Sep. 18, 2023
# Define some parameters and add some comments.

# Source name
# Used in main.sh to move to the right diretory.
# Now, only support one source with multiple observations.
source_name=MRK1216
export source_name

# Observation IDs.
# Used in unpack.sh to create directories.
# Used in image.sh for the command evselect.
# Used in lightcurve.sh for the command rgslccorr.
# Used in background.sh for the command evselect.
# Used in spectra.sh for the commands rgscombine and rgsfluxer.
# obsids=(0822960101 0822960201)
obsids=(0822960101)
export obsids

# Right ascention and declination in degree.
# Used in rgsproc.sh for the command rgsproc.
ra_deg=127.196292
export ra_deg
dec_deg=-6.940139
export dec_deg

# Image size in x and y direction, default (900,600). 
# Used in image.sh for the command evselect.
ximagesize=900
export ximagesize
yimagesize=600
export yimagesize

# Size of time bin.
# Used in lightcurve.sh for the command rgslccorr.
# Used in background.sh for the command evselect.
timebinsize=100
export timebinsize

# RGS ID and exposure ID.
# Used in image.sh for the command evselect and cxctods9.
# Used in lightcurve.sh for the command rgslccorr.
# Used in background.sh for the command evselect.
# Used in spectra.sh for the commands rgscombine and rgsfluxer.
rgsid=(1 2)
export rgsid
expid=(S004 S005)
export expid

# Size of image regions, specified by the percentage of the cross-dispersion PSF covered between each pair of vertices with the same dispersion coordinate.
# Used in rgsproc.sh for the command rgsproc.
# xpsfincls=(90 90)
xpsfincls=(90)
export xpsfincls
# Size of the exclusion regions in the background region, specified by the percentage of the cross-dispersion PSF covered between each pair of vertices with the same dispersion coordinate and associated source.
# Used in rgsproc.sh for the command rgsproc.
# xpsfexcls=(95 95)
xpsfexcls=(95)
export xpsfexcls

# Source ID.
# Used in image.sh for the command cxctods9.
# Used in lightcurve.sh for the command rgslccorr.
# Used in spectra.sh for the commands rgscombine and rgsfluxer.
srcid=3

# Number of sigma about the mean count rate to use to clip outliers.
# Used in deflare2.sh for the command deflare.
# 3.0 is the default value.
# nsigmas=(3.0 3.0)
nsigmas=(3.0)

# Note that there may be some other parameters to be set, which depends on your task.
###################
# Note that obsids, xpsfincls, xpsfexcls, and nsigmas must be of the same length!
###################

#!/bin/bash
# This shell script should be executed in directory work_dir/targets/$source_name.
# Unpack compressed data file, which is obsid.tar.gz.
# The 1st shell script.
# Author: Guan-Fu Liu
# Date: Sep. 18, 2023
# Add some comments and some if statements.
echo "You should input the observation ID and some other necessary parameters in parameter.sh first.\n"
rm -rf ${obsid}-${xpsfincl}-${xpsfexcl}-${nsigma}
mkdir -p ${obsid}-${xpsfincl}-${xpsfexcl}-${nsigma}/odf
mkdir -p ${obsid}-${xpsfincl}-${xpsfexcl}-${nsigma}/epic
mkdir -p ${obsid}-${xpsfincl}-${xpsfexcl}-${nsigma}/rgs
FILE=${obsid}.tar.gz
if [ -f "$FILE" ]; then
    echo "$FILE exists."
    tar -xvf ${obsid}.tar.gz -C ${obsid}-${xpsfincl}-${xpsfexcl}-${nsigma}/odf
    tar -xf ./${obsid}-${xpsfincl}-${xpsfexcl}-${nsigma}/odf/*.TAR -C ./${obsid}-${xpsfincl}-${xpsfexcl}-${nsigma}/odf 
    rm  ./${obsid}-${xpsfincl}-${xpsfexcl}-${nsigma}/odf/*.TAR

else 
    echo "$FILE does not exist."
    rm -rf ${obsid}-${xpsfincl}-${xpsfexcl}-${nsigma}
    return
fi
# Copy the rest shell scripts to where they should be.
cp $work_dir/shell-scripts/initialize.sh $work_dir/targets/$source_name/${obsid}-${xpsfincl}-${xpsfexcl}-${nsigma}/odf/
# parameter.sh will stay in work_dir/shell-scripts.
rsync -rv $work_dir/shell-scripts/ $work_dir/targets/$source_name/${obsid}-${xpsfincl}-${xpsfexcl}-${nsigma}/rgs --exclude={initialize.sh,parameter.sh,main.sh,obs-comb.sh,obs-joint.sh}

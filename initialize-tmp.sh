#!/bin/bash
# This shell script should be executed in directory work_dir/.../odf.
# Initialize SAS, run cifbuild and execute odfingest.
# The 2nd shell script.
# Author: Guan-Fu Liu
# Date: Feb. 20, 2023
# Add some if statements.
# source $work_dir/shell-scripts/parameter.sh
SAS_DIR=/Users/liuguanfu/Workspace/SAS-21
source $SAS_DIR/heasoft-6.32.1/heasoft_initialize.sh
source $SAS_DIR/xmmsas_20230412_1735/setsas.sh
SAS_ODF=$PWD
export SAS_ODF
SAS_CCFPATH=/Users/liuguanfu/Workspace/SAS-21/CCF
export SAS_CCFPATH
cifbuild
SAS_CCF=$PWD/ccf.cif
export SAS_CCF
odfingest
SAS_ODF=$PWD/$(ls -1 *SUM.SAS)
export SAS_ODF
echo "\n\n\n"
echo "SAS_ODF=$SAS_ODF\n"
echo "SAS_CCF=$SAS_CCF\n"

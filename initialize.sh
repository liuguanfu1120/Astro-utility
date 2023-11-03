#!/bin/bash
# This shell script should be executed in directory work_dir/.../odf.
# Initialize SAS, run cifbuild and execute odfingest.
# The 2nd shell script.
# Author: Guan-Fu Liu
# Date: Sep. 18, 2023
# Add some if statements.
# source $work_dir/shell-scripts/parameter.sh
SAS_DIR=/Users/liuguanfu/Workspace/SAS-21
source $SAS_DIR/heasoft-6.32.1/heasoft_initialize.sh
source $SAS_DIR/xmmsas_20230412_1735/setsas.sh
SAS_ODF=$PWD
export SAS_ODF
SAS_CCFPATH=/Users/liuguanfu/Workspace/SAS-21/CCF
export SAS_CCFPATH
FILE=ccf.cif
if [ -f "$FILE" ]; then
    echo "$FILE exists.\n"
    echo "cifbuild command may have been executed! Please check it!"
    echo "Shall cifbuild be re-executed? (yes or no)"
    while true
    do
        read yn
        case $yn in
            [Yy]* ) 
                echo "Proceeding!"
                rm $FILE
                cifbuild
                break;;
            [Nn]* ) 
                echo "Do not re-execute cifbuild."
                break;;
            * ) 
                echo "Please answer yes or no.";;
        esac
    done
else 
    echo "$FILE does not exist. cifbuild will be executed."
    cifbuild
fi
SAS_CCF=$PWD/ccf.cif
export SAS_CCF
if [ $(ls *SUM.SAS | wc -l) -gt 0 ]; then
    echo "odfingest command may have been executed! Please check it!"
    echo "Shall odfingest be re-executed? (yes or no)"
    while true
    do
        read yn
        case $yn in
            [Yy]* ) 
                echo "Proceeding!"
                FILE=$(ls -1 *SUM.SAS)
                rm $FILE
                odfingest
                break;;
            [Nn]* ) 
                echo "Do not re-execute odfingest."
                break;;
            * ) 
                echo "Please answer yes or no.";;
        esac
    done
else 
  echo "odfingest has not been executed!\n"
  echo "odfingest will be executed right away.\n\n\n"
  odfingest
fi
SAS_ODF=$PWD/$(ls -1 *SUM.SAS)
export SAS_ODF
echo "\n\n\n"
echo "SAS_ODF=$SAS_ODF\n"
echo "SAS_CCF=$SAS_CCF\n"

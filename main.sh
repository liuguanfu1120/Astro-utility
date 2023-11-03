#!/bin/bash
# Author: Guan-Fu Liu
# Date: Sep. 18, 2023
# Run the pipeline all in one.
# The pipeline goes as follows,
# 0. Modify parameter.sh
# 1. Source unpack.sh
# 2. Source initialize.sh
# 3. Source rgsproc.sh
# 4. Source image.sh
# 5. Source lightcurve.sh
# 6. Source background.sh
# 7. Source deflare2.sh (or deflare1.sh)
# 8. Source spectra.sh
# 9. Source OGIPtoSpex.sh, convert single observation to spex format
# 10. Source obs-comb.sh, combine multiple observations
# 11. Source obs-joint.sh, joint the combined observation
# All the shell scripts are in the directory work_dir/shell-scripts.

echo "Did you input the right parameters in paramter.sh? (yes or no)\n"
while true
do
    read yn
    case $yn in
        [Yy]* ) 
            echo "Proceeding!"
            break;;
        [Nn]* ) 
            echo "Stop here!"
            return
            # return will skip the rest of this shell script.
            # break here is just for completing the while loop.
            break;;
        * ) 
            echo "Please answer yes or no.";;
    esac
done

# Move to work_dir
cd ..
# In work_dir
work_dir=$PWD
export work_dir
cp $work_dir/shell-scripts/unpack.sh $work_dir/targets/$source_name/
cp $work_dir/shell-scripts/obs-comb.sh $work_dir/targets/$source_name/
# Move to the directory that contains obsid.tar.gz
cd $work_dir/targets/$source_name/
source $work_dir/shell-scripts/parameter.sh
# Move to work_dir/targets/$source_name
cd $work_dir/targets/$source_name
len1=${#obsids[@]}
len2=${#xpsfincls[@]}
len3=${#xpsfexcls[@]}
len4=${#nsigmas[@]}
if [ "$len1" -eq "$len2" ] && [ "$len2" -eq "$len3" ] && [ "$len3" -eq "$len4" ]; then
    echo "The lengths of the lists (obsids, xpsfincls, xpsfexcls, nsigmas) are the same."
else
    echo "The lengths of the lists (obsids, xpsfincls, xpsfexcls, nsigmas) are not the same."
    echo "Exit!"
    exit 0
fi

for i in $(seq 1 $len1)
do
    obsid=${obsids[$i]}
    xpsfincl=${xpsfincls[$i]}
    xpsfexcl=${xpsfexcls[$i]}
    nsigma=${nsigmas[$i]}
    source unpack.sh 2>&1 | tee unpack.log
    # tee will open a subshell and unset the environment variables defined in parameter.sh.
    # So stop using tee.
    # source unpack.sh > unpack.log 2>&1
    # echo "cat the file unpack.log"
    # cat unpack.log
    # Move to work_dir/obsid/odf
    cd $work_dir/targets/$source_name/${obsid}-${xpsfincl}-${xpsfexcl}-${nsigma}/odf
    # In work_dir/obsid/odf
    ##############################
    # tee will always introduce a subshell!
    # So the environment variables defined in initialize.sh will be unset!
    # We cannot use tee here.
    ##############################
    echo "The standard output and standard error will be redirected to the file initialize.log"
    source initialize.sh > initialize.log 2>&1
    echo "cat the file initialize.log"
    cat initialize.log
    # Move to work_dir/obsid/rgs
    cd $work_dir/targets/$source_name/${obsid}-${xpsfincl}-${xpsfexcl}-${nsigma}/rgs
    source rgsproc.sh 2>&1 | tee rgsproc.log
    source image.sh 2>&1 | tee image.log
    source lightcurve.sh 2>&1 | tee lightcurve.log
    source background.sh 2>&1 | tee background.log
    # echo "The standard output and standard error will be redirected to the file deflar2.log"
    source deflare2.sh 2>&1 | tee deflare2.log
    # source deflare2.sh > deflare2.log 2>&1
    # cat deflare2.log
    # source deflare2-old.sh 2>&1 | tee deflare2-old.log
    source spectra.sh 2>&1 | tee spectra.log
    source OGIPtoSpex.sh 2>&1 | tee OGIPtoSpex.log
    cd $work_dir/targets/$source_name
done
cd $work_dir/targets/$source_name
cp $work_dir/shell-scripts/obs-comb.sh $work_dir/targets/$source_name/obs-comb.sh
cp $work_dir/shell-scripts/obs-joint.sh $work_dir/targets/$source_name/obs-joint.sh
if [ "$len1" -gt 1 ]; then
    echo "Please check that you do not input any same obsid in parameter.sh."
    echo "Combine and join the observations (yes or no)?"
    while true
    do
        read yn
        case $yn in
            [Yy]* ) 
                echo "Combine and join the observations!"
                source obs-comb.sh 2>&1 | tee obs-comb.log
                source obs-joint.sh 2>&1 | tee obs-joint.log
                break;;
            [Nn]* ) 
                echo "Do not combine and join the observations!"
                break;;
            * ) 
                echo "Please answer yes or no.";;
        esac
    done

else
    echo "Only one observation. Skip obs-comb.sh and obs-joint.sh."
fi
cd $work_dir/shell-scripts

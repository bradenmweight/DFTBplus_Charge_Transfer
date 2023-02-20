#!/bin/bash

# ==== NEED TO CHANGE EVERY TIME ================
NVT_geom_file=$(echo "../NVT_1fs_step/geom.out.xyz")
sbatch_file=$(echo "4_core_dftb.sbatch")
NVE_input_file=$(echo "../NVE_input.hsd")
natoms=$(head -1 ${NVT_geom_file})
# "xyz_to_dftb_input.sh" also need to be changed.
# ==== NEED TO CHANGE EVERY TIME ================

#======================================================
# create a input.xyz for each 2000 steps (total = 60000 fs.
# 2000*30 = 60,000 fs. Thus, we considered 2000 timesteps,
# i.e. 1.0 ps, to uncorrelate the individual trajectories.
#======================================================
# In the "start_line" below, 2000 is the number of steps skipped = 1.0 ps skipped

#for i in $(seq 1 1) 
for i in $(seq 1 30) 
do
 start_line=$(echo "(${i} * 2000 * $(($natoms+2))) + 1 " | bc -l) 
 end_line=$(echo "${start_line} + ${natoms} + 1" | bc -l) # if StartLine (SL) = 1, then EndLine = 258 + 2 = NAt + SL + 1
 sed -n "${start_line},${end_line}p;${end_line}q" ${NVT_geom_file} > ${i}th_step.xyz

#======================================================
# Create Sep directories, prepare .bind files and run Yaehmop
#======================================================
 mkdir ${i}th_step
 cp ${sbatch_file} xyz_to_dftb_input.sh ${i}th_step
 mv ${i}th_step.xyz ${i}th_step
 cd ${i}th_step
 cp ${NVE_input_file} dftb_in.hsd
 ./xyz_to_dftb_input.sh ${i}th_step.xyz
 sbatch ${sbatch_file}
 cd ../
done 


#!/bin/bash

# ==== NEED TO CHANGE EVERY TIME ================
sbatch_file=$(echo "1_core_dftb.sbatch")
NVE_input_file=$(echo "NVE_input_for_namd.hsd")
# "xyz_to_dftb_input.sh" also need to be changed.

# ==== NEED TO CHANGE EVERY TIME ================
for i in $(seq 1 50); do

  # Copy various files including namd.inp
  cp ${sbatch_file} ${NVE_input_file} namd.inp xyz_to_dftb_input.sh ${i}th_step

  cd ${i}th_step
    # Get Positions and Velocities from the NVT run. Charges CANNOT be stored for each step during NVT run.
    ./xyz_to_dftb_input.sh ${i}th_step.xyz
    cat ${i}th_step.xyz | awk '{if(NR>2) print $6, $7, $8}' > vel_from_NVT.xyz
    
    # Rename the dftb input and run the job
    mv ${NVE_input_file} dftb_in.hsd
    sbatch ${sbatch_file}
  cd ../
done 


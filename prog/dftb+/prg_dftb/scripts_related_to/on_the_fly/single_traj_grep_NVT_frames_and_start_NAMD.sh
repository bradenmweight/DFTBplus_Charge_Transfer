#!/bin/bash

# ==== NEED TO CHANGE EVERY TIME ================
#sbatch_file=$(echo "4_core_dftb.sbatch")
NVE_input_file=$(echo "NVE_input_for_namd.hsd")
# "xyz_to_dftb_input.sh" also need to be changed.

#natoms=$(head -1 "${NVE_equilib_dir}/1th_step/geom.out.xyz")
#NVE_equilib_dir=$(echo "/gpfs/fs2/scratch/syamija2/projects/OPV_related/calculations/h2pc_C60/2h2pc_1c60_f/dftb_calcs/5ps_NVE_traj_dftb17.1/")
# ==== NEED TO CHANGE EVERY TIME ================


for i in $(seq 1 1); do

  # Copy various files including namd.inp
  cp ${sbatch_file} ${NVE_input_file} namd.inp xyz_to_dftb_input.sh ${i}th_step

  cd ${i}th_step
    # Get Positions, Velocities and Charges from the NVT run. Charges are not required
    ./xyz_to_dftb_input.sh ${i}th_step.xyz
    cat ${i}th_step.xyz | awk '{if(NR>2) print $6, $7, $8}' > vel_from_NVT.xyz
    #cp "${NVE_equilib_dir}/${i}th_step/charges.bin" .
    
    # Rename the dftb input and run the job
    mv ${NVE_input_file} dftb_in.hsd
    #sbatch ${sbatch_file}
  date > output.log
  time /home/syamija2/Softwares/dftb/on_the_fly_dynamics/FSSH_dftb_17.1/_install/bin/dftb+ < dftb_in.hsd >>  output.log
  date >>  output.log
  cd ../
done 


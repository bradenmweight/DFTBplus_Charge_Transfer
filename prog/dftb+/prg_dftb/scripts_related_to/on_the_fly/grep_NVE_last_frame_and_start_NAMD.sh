#!/bin/bash

# ==== NEED TO CHANGE EVERY TIME ================
NVE_equilib_dir=$(echo "/gpfs/fs2/scratch/syamija2/projects/OPV_related/calculations/h2pc_C60/2h2pc_1c60_f/dftb_calcs/5ps_NVE_traj_dftb17.1/")
sbatch_file=$(echo "4_core_dftb.sbatch")
NVE_input_file=$(echo "NVE_input_for_namd.hsd")
natoms=$(head -1 "${NVE_equilib_dir}/1th_step/geom.out.xyz")
# "xyz_to_dftb_input.sh" also need to be changed.
# ==== NEED TO CHANGE EVERY TIME ================


for i in $(seq 1 30); do
  #mkdir ${i}th_step
  #tail -$(echo "$natoms + 2" | bc -l) "${NVE_equilib_dir}/${i}th_step/geom.out.xyz" > ${i}th_step/${i}th_step_5ps_geom.xyz

  # Copy various files including namd.inp
  cp ${sbatch_file} ${NVE_input_file} namd.inp xyz_to_dftb_input.sh ${i}th_step

  cd ${i}th_step
    # Get Positions, Velocities and Charges from the last NVE run
    ./xyz_to_dftb_input.sh ${i}th_step_5ps_geom.xyz
    cat ${i}th_step_5ps_geom.xyz | awk '{if(NR>2) print $6, $7, $8}' > vel_after_5ps_NVE.xyz
    cp "${NVE_equilib_dir}/${i}th_step/charges.bin" .
    
    # Rename the dftb input and run the job
    mv ${NVE_input_file} dftb_in.hsd
    sbatch ${sbatch_file}
  cd ../
done 


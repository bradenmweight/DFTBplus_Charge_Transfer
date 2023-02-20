#!/bin/bash
#SBATCH -p action -A action
##SBATCH -p exciton -A exciton
#SBATCH -J gen_zero_Bq
#SBATCH -o my_output_%a_%j
#SBATCH --mem-per-cpu=2GB
#SBATCH -t 120:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH -a 1-30

export OMP_NUM_THREADS=8
module load dftbplus/17.1/b2

# Remember that the Diff b/w donor and acceptor will be there in num ads_atoms and LUMO_begin

Bq_0_inp_dir=/gpfs/fs2/scratch/syamija2/projects/OPV_related/calculations/h2pc_C60/2h2pc_1c60_f/namd_calcs/avg_30_traj/with_dimer_LUMO/restart_NVEs_with_on_the_fly/scripts_to_gen_Bq_zero/

NVE_equilib_dir=/gpfs/fs2/scratch/syamija2/projects/OPV_related/calculations/h2pc_C60/2h2pc_1c60_f/dftb_calcs/5ps_NVE_traj_dftb17.1/

natoms=$(head -1 "${NVE_equilib_dir}/1th_step/geom.out.xyz")

date

# --------- Generate input for grepping adsorbate atoms ------

nadsorbate_atoms=116 # donor = 2H2PC
adsorbate_atom_list=$(echo $(seq 1 116))

mkdir ${SLURM_ARRAY_TASK_ID}th_step
cd ${SLURM_ARRAY_TASK_ID}th_step
 
  # Get the last geometry from the previous NVE run
  tail -$(echo "$natoms + 2" | bc -l) "${NVE_equilib_dir}/${SLURM_ARRAY_TASK_ID}th_step/geom.out.xyz" > ${SLURM_ARRAY_TASK_ID}th_step_5ps_geom.xyz

  #----------------------------------------------------------------------------
  # Finding important Bqs and copying Bq_zero.txt for running your code
  #----------------------------------------------------------------------------
  
  rm -rf zero_bq_donor
  mkdir zero_bq_donor
  cp ${SLURM_ARRAY_TASK_ID}th_step_5ps_geom.xyz zero_bq_donor
  cp ${SLURM_ARRAY_TASK_ID}th_step_5ps_geom.xyz zero_bq_donor/traj_zero
  cp ${Bq_0_inp_dir}/0Bq_donor_print_eigvals_eigvecs_dftb_in.hsd zero_bq_donor/dftb_in.hsd
  
  # Enter the directory, run job and get eigvecs and eigvals 
  
  cd zero_bq_donor
  ${Bq_0_inp_dir}/0Bq_donor_xyz_to_dftb_input.sh traj_zero
  dftb+ < dftb_in.hsd >>  output.log
  
  cat eigenvec.out | sed '/Eige/d' | sed '1d' | sed '/^\s*$/d' | sed '/^$/d'| awk '{printf"%12.6f\n", $(NF-1)}' > eigvecs_zero.out
  cat detailed.out | awk '$1 ~ /Eigenvalues/ && $2 ~ /\/eV/, $0 ~ /Fillings/' | head -n-2 | sed '1d' > eigvals_zero.out
  mkdir only_for_eigvecs_eigvals
  cp * only_for_eigvecs_eigvals
  
  # Some important numbers 
  HOMO=$(grep "     2.00000" detailed.out | wc -l)
  nbasis=$(wc -l eigvals_zero.out | awk '{print $1}')
  echo HOMO is $HOMO >> output.log
  echo nbasis is $nbasis >> output.log
  echo $nbasis > input_ao_to_mo.txt
  
  # ----------------------------
  # Following lines are commented as they are creating confusion and as they are not required.
  lumo_begin=$(( ${HOMO}*${nbasis} + 1 ))
  lumo_end=$(( $(($HOMO + 1))*$nbasis))
  sed -n "${lumo_begin},${lumo_end}p;${lumo_end}q" ./eigvecs_zero.out > LUMO_entire_system.txt
  # ----------------------------
  
  # Re-run the job to get overlap 
  cp ${Bq_0_inp_dir}/0Bq_donor_print_overlap_dftb_in.hsd dftb_in.hsd
  dftb+ < dftb_in.hsd >>  output.log
  sed '1,5d' oversqr.dat > ./overlap_zero.dat
  
  mkdir overlap
  cp * overlap
  
  # ===================================
  # ADSORBATE related stuff STARTS here 
  # ===================================
  
  echo ${nadsorbate_atoms} > input_get_adsorbate.txt
  for i in $(echo ${adsorbate_atom_list})
  do
   echo $i >> input_get_adsorbate.txt
  done
  
  # Again Re-run the job with only adsorbate system
  cp ${Bq_0_inp_dir}/0Bq_donor_print_eigvals_eigvecs_dftb_in_ads.hsd dftb_in.hsd
  ${Bq_0_inp_dir}/get_adsorbate_from_traj_zero.o < input_get_adsorbate.txt
  ${Bq_0_inp_dir}/0Bq_donor_xyz_to_dftb_input.sh adsorbate.xyz
  dftb+ < dftb_in.hsd >>  output.log
  
  cat eigenvec.out | sed '/Eige/d' | sed '1d' | sed '/^\s*$/d' | sed '/^$/d'| awk '{printf"%12.6f\n", $(NF-1)}' > eigvecs_adsorbate.out
  cat detailed.out | awk '$1 ~ /Eigenvalues/ && $2 ~ /\/eV/, $0 ~ /Fillings/' | head -n-2 | sed '1d' > eigvals_adsorbate.out
  
  # Some important numbers 
  HOMO=$(grep "     2.00000" detailed.out | wc -l)
  nbasis=$(wc -l eigvals_adsorbate.out | awk '{print $1}')
  echo HOMO is $HOMO >> output.log
  echo nbasis is $nbasis >> output.log
  
  homo_begin=$(( $(( ${HOMO} - 1))*${nbasis} + 1 )) # HOMO - 1 is for HOMO
    homo_end=$(( $(( ${HOMO} + 0))*${nbasis} ))
  
  lumo_begin=$(( $(( ${HOMO} + 0))*${nbasis} + 1 )) # HOMO + 0 is for LUMO
    lumo_end=$(( $(( ${HOMO} + 1))*${nbasis} ))
  
  lumo_plus_begin=$(( $(( ${HOMO} + 1))*${nbasis} + 1 )) # HOMO + 1 is for LUMO+1
    lumo_plus_end=$(( $(( ${HOMO} + 2))*${nbasis} ))
  
  # Use correct begin and end to get the correct MO for Bq_zero.
  #sed -n "${homo_begin},${homo_end}p;${homo_end}q" ./eigvecs_adsorbate.out > LUMO_adsorbate.txt
  sed -n "${lumo_begin},${lumo_end}p;${lumo_end}q" ./eigvecs_adsorbate.out > LUMO_adsorbate.txt
  #sed -n "${lumo_plus_begin},${lumo_plus_end}p;${lumo_plus_end}q" ./eigvecs_adsorbate.out > LUMO_adsorbate.txt

  # Get the Bq zero information and move it to the previous directory 
  ${Bq_0_inp_dir}/write_ads_lumo_in_full_basis.o
  ${Bq_0_inp_dir}/full_basis_lumo_to_B_q_zero.o < input_ao_to_mo.txt
  cp B_q_zero.txt ../B_q_zero_donor.txt
  cp B_q_zero.txt ../
  echo "B_q_zero done for zeroth_step"
  # =====================================================================================   
  # -----------------  ADSORBATE related stuff ENDS here -----------------------------
  # =====================================================================================   
  
  # --------- Get out of the directory ---------------------
cd ../
date

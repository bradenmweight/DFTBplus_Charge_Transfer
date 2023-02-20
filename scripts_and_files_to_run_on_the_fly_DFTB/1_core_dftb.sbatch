#!/bin/bash
#SBATCH -p standard
##SBATCH -p action -A action
#SBATCH -J dftb_print_E_Q_S
#SBATCH -o my_output_%j
#SBATCH --mem-per-cpu=2GB
#SBATCH -t 120:00:00
#SBATCH -N 1 -n 1 -c 1

export OMP_NUM_THREADS=1

date > output.log
time /home/syamija2/Softwares/dftb/on_the_fly_dynamics/FSSH_dftb_17.1/_install/bin/dftb+ < dftb_in.hsd >>  output.log
#dftb+ < dftb_in.hsd >>  output.log
date >>  output.log

#/home/syamija2/Softwares/dftb/1.2.2/dftb+_1.2.2_src/prg_dftb/_obj_bluehive/dftb+ < dftb_in.hsd >>  output.log

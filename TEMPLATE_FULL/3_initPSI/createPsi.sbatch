#!/bin/bash
#SBATCH -p exciton -A exciton
#SBATCH -J DFTB+_makePsi
#SBATCH -o output.slurm
#SBATCH -t 2:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem 5GB

python createPsi.py 200 0
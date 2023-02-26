#----------------------------
# Use this as : 
# python optimize.py file.xyz
# ---------------------------
import dftb
import os
import sys

cores   = 8
charge  = 0.0

# other system specific input
fermiTemperature = 300.0
maxIter = 1000


# Location for input xyz file
xyzFile = sys.argv[1]
# Clean the working directory
dftb.clean()
# Creating Dftb Input file
dftb.dftbInputOpt(xyzFile, charge, maxIter, fermiTemperature)
# Creating sbatch file for dftb
dftb.useTemplate('opt.sbatch.tem',{'cores' : cores})
# Submitting sbatch
subId = dftb.sbatch('opt.sbatch')
# Obtain geometry in future
dftb.useTemplate('getGeom.sh.tem',{'cores' : 1})
# Runs only when optimization is done
os.system("sbatch --dependency=afterok:%s getGeom.sh"%(subId))

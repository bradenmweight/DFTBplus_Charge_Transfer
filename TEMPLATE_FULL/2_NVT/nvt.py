#----------------------------
# Use this file as:
# python nvt.py INPUT.XYZ, DEFAULT: ../optimize/optimized.xyz
# ---------------------------

import os
import dftb
import sys

# Inputs for your Simulation
cores = 12
temperature = 300 # Kelvin
timeStep = 1.0 # Femto Seconds
simTime = 0.1 # ps
steps =  int( simTime * 10 ** 3 // timeStep )
print (f"\n\tSimulation will run for {steps} steps with dt = {timeStep} fs for a total length of {simTime} ps.\n")
print (f'''Run this command to track progress: watch " grep 'Geometry step:' output.log | tail -n 20 " ''' )
other = {'CouplingStrength': 1000, 'Fermi': 300, 'Charge': 0.0}

# Input for Post Processing 
grabGeometries = 50 # How many initial conditions do you want to sample from GS dynamics?



try :
    optimizedXYZ = sys.argv[1]
except:
    # Location for optimized xyz file
    optimizedXYZ = "geometry.xyz"

# Creating Dftb Input file
dftb.dftbInputNVT(optimizedXYZ, temperature, timeStep, steps, other ) 
# Creating sbatch file for dftb
dftb.useTemplate("nvt.sbatch.tem",{'cores' : cores})
# Submitting sbatch
subId = dftb.sbatch('nvt.sbatch')
# Obtain geometries in future
dftb.useTemplate("getGeom.sh.tem",{'cores' : 1, 'N': grabGeometries})
# Runs only when nvt is done
os.system("sbatch --dependency=afterok:%s getGeom.sh"%(subId))


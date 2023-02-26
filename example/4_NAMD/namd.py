import os, sys
import dftb
dftbNamd = "/scratch/bweight/software/FSSH_dftb_17.1/_install/bin/dftb+"

#----------------------
cores = 1 # Keep as "1"
nuclearTraj = 50 # Number of nuclear initial conditions
fermiTemp  = 300 # WHAT IS THIS??? ~BMW 
Charge = 0.0
timeStep = 0.25 # fs
simTime = 1000 # fs
steps = int( simTime / timeStep )
elecSteps = 250
activeSpace = 10 # This is the number of states available for electronic dynamics. Choose larger than initiailly populated state to get coherences.
#-----------------------

print (f"\n\tSimulation will run for {steps} steps with dt = {timeStep} fs for a total length of {simTime} fs.\n")
print (f'''Run this command to track progress: watch " grep 'Geometry step:' output.log | tail -n 20 " ''' )

info = open("../3_initPSI/step1/info.txt","r").readlines()
frags = 2
#HOMO = int(info[1].replace("\n",""))
HOMO = int(float(info[1].split('\n')[0]))

donorBasis = int(info[3].replace("\n",""))
totalBasis = int(info[5].replace("\n",""))

for i in range(1,nuclearTraj+1):
    os.system("mkdir step%s"%(i))
    # Copying B_q_zero file
    os.system("cp ../3_initPSI/step%s/Psi.txt  ./step%s/B_q_zero.txt"%(i,i))
    # make the dftb input
    other = {'Fermi': fermiTemp, 'Charge': Charge} ### CAN WE DO CHARGED DYNAMICS ??? THAT WOULD BE COOL AND RELAVENT.
    dftb.dftbInputNamd("../2_NVT/output/nvt%s.xyz"%(i),timeStep, steps,other)
    # copy dftb input
    os.system("mv namd.hsd ./step%s/dftb_in.hsd"%(i))
    # create namd input
    # fragments
    fragments = "1\t%s\n%s\t%s"%(donorBasis,donorBasis+1,totalBasis) # THIS LINE CONTROLS CHARGE TRACKING MAYBE???
    values = { 'beginSurfID' : HOMO, # This is the lowest active state in electron dynamics.
               'endSurfID' : HOMO + activeSpace, # This is the top-most active state for electron dynamics
               'fragments' : fragments,
               'eStep' : elecSteps
                }
    dftb.useTemplate("namd.inp.tem",values)
    os.system("mv namd.inp ./step%s/namd.inp"%(i))
    # Sbatch file create
    dftb.useTemplate("namd.sbatch.tem",{'cores': cores, 'dftbNamd': dftbNamd})
    os.system("mv namd.sbatch  ./step%s/namd.sbatch"%(i))
    # Run Sbatch 
    os.chdir("step%s"%(i))
    os.system("sbatch namd.sbatch")
    os.chdir("../")
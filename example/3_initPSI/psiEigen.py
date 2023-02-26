import os, sys
import dftb
import time

# ---------- Inputs --------------------
step = 50 # NUMBER OF INITIAL CONDITIONS FROM BO S0 NVT DYNAMICS
cores = 1 # NO NEEED TO USE MORE THAN 1
yourId = "bweight"
LUMO = 0 # 0 = LUMO, 1 = LUMO + 1 of DONOR part
donorAtoms = range(60)  # First {donorAtoms} atoms need to be from DONOR part... # NEED TO REWRITE THIS CODE TO just be able to SAY WHAT STATE WE WANT...
other = {'Fermi': 300, 'Charge': 0.0}
#---------------------------------------

# Generating MO having all atoms (Donor & Acceptor)
AllJobs = []
for i in range(1,step+1):
    print ("All Atoms", i)
    os.system("mkdir step%s"%(i))
    # Input file for dftb psi and Eigenvalue
    dftb.dftbInputPsiEigen("../2_NVT/output/nvt%s.xyz"%(i), 'No', other)
    os.system("mv PsiEigen.hsd step%s/dftb_in.hsd"%(i))
    # sbatch file for dftb
    dftb.useTemplate("dftb.sbatch.tem",{'cores':1})
    os.system("mv dftb.sbatch step%s/PsiEigen.sbatch"%(i))
    # --- Run Job ---------
    os.chdir("step%s"%(i))
    jobId = os.popen("sbatch PsiEigen.sbatch").read().split()[3].replace("\n","")
    AllJobs.append(int(jobId))
    os.chdir("../")

#------ Check if All jobs are done | wait till they are done 
jobsDone = False 
while not (jobsDone) : 
    jobsDone = True
    for i in AllJobs:
        if dftb.checkJob(i, yourId):
            jobsDone = False
            time.sleep(5)

#--------- Copy the MOs of all system -----------------------
for i in range(1,step+1):
    os.chdir("step%s"%(i))
    if ( not os.path.exists("MO") ): os.system("mkdir MO")
    if ( os.path.isfile("eigenvec.out")): os.system("mv eigenvec.out ./MO/")
    if ( os.path.isfile("detailed.out")): os.system("mv detailed.out ./MO/")
    os.chdir("../")
#----------------------------------------------------------------
AllJobs = []
# Generating Overlaps having all atoms (Donor & Acceptor)
for i in range(1,step+1):
    print ("Overlaps, all", i)
    # Input file for dftb psi and Eigenvalue
    dftb.dftbInputPsiEigen("../2_NVT/output/nvt%s.xyz"%(i),'Yes', other)
    os.system("mv PsiEigen.hsd step%s/dftb_in.hsd"%(i))
    # sbatch file for dftb
    dftb.useTemplate("dftb.sbatch.tem",{'cores':1})
    os.system("mv dftb.sbatch step%s/PsiEigen.sbatch"%(i))
    # --- Run Job ---------
    os.chdir("step%s"%(i))
    jobId = os.popen("sbatch PsiEigen.sbatch").read().split()[3].replace("\n","")
    AllJobs.append(int(jobId))
    os.chdir("../")

#------ Check if All jobs are done | wait till they are done 
jobsDone = False 
while not (jobsDone) : 
    jobsDone = True
    for i in AllJobs:
        if dftb.checkJob(i, yourId):
            jobsDone = False
            time.sleep(5)

#--------- Copy the overlaps of all system -----------------------
for i in range(1, step+1):
    os.chdir("step%s"%(i))
    os.system("mkdir overlap")
    os.system("mv oversqr.dat ./overlap/")
    os.chdir("../")
#----------------------------------------------------------------

# -------------- Jobs for Donor is Run ------------------------------------------------
AllJobs = []
for i in range(1, step+1):
    print ("DONOR", i )
    # create xyz file for Donor 
    #dftb.getDonorGeom("../2_NVT/output/nvt%s.xyz"%(i), donorAtoms,"step%s/donor.xyz"%(i))
    dftb.getDonorGeom_Braden("../2_NVT/output/nvt%s.xyz"%(i), donorAtoms,"step%s/donor.xyz"%(i))
    # DFTB input for donor
    dftb.dftbInputPsiEigen("step%s/donor.xyz"%(i),  'No', other)
    os.system("mv PsiEigen.hsd step%s/dftb_in.hsd"%(i))
    # sbatch file for dftb
    dftb.useTemplate("dftb.sbatch.tem",{'cores':1})
    os.system("mv dftb.sbatch step%s/PsiEigen.sbatch"%(i))
    # --- Run Job ---------
    os.chdir("step%s"%(i))
    jobId = os.popen("sbatch PsiEigen.sbatch").read().split()[3].replace("\n","")
    AllJobs.append(int(jobId))
    os.chdir("../")

#------ Check if All jobs are done | wait till they are done 
jobsDone = False 
while not (jobsDone) : 
    jobsDone = True
    for i in AllJobs:
        if dftb.checkJob(i, yourId):
            jobsDone = False
            time.sleep(5)
#-----------------------------------------------------------

#--------- Copy the MOs of donor system -----------------------
for i in range(1,step+1):
    os.chdir("step%s"%(i))
    os.system("mkdir donorMO")
    os.system("mv eigenvec.out ./donorMO/")
    os.system("mv detailed.out ./donorMO/")
    os.chdir("../")
#----------------------------------------------------------------


for i in range(1, step+1):
    dftb.useTemplate("createPsi.sbatch.tem",{'ith':i, 'LUMO' : LUMO })
    dftb.sbatch("createPsi.sbatch")

print('''Check jobs with watch "sqme | grep DFT | wc -l" ''')
import dftb
import sys
import os 
import numpy as np

i = sys.argv[1]
LUMO = sys.argv[2]
os.chdir("step%s"%(i))
# --- info file -------
info = open("info.txt","w+") 
# ---------------------

#----- Get Homo -----------------------------
HOMO = dftb.findHomo("./MO/detailed.out")
print ("HOMO is :", HOMO)
info.writelines("HOMO:\n%s\n"%(HOMO))
donorHOMO = dftb.findHomo("./donorMO/detailed.out")
print ("HOMO of donor is :", donorHOMO)
donorMO = donorHOMO + int(LUMO) + 1 # Using ith LUMO
#----- Get LUMO or LUMO+x ------------------
initMO = dftb.getPsi(donorMO,"donor.xyz","./donorMO/eigenvec.out")
fullMO1 = dftb.getPsi(1,"../../2_NVT/output/nvt%s.xyz"%(i),"./MO/eigenvec.out")

info.writelines("donor Basis\n%s\n"%(str(len(initMO))))
info.writelines("total Basis\n%s\n"%(str(len(fullMO1))))
info.close()
#----- Initial MO in bigger Basis -----------
#print ("Full Basis:")
#print (fullMO1)
#print ("Donor Basis:")
#print (initMO)
#print("\n")
initMO = dftb.expandPsi(initMO, fullMO1)
#print (initMO)
#----- Get the overlap for conversion -------
olap = dftb.overlap('overlap/oversqr.dat')
#--------------------------------------------
# expanding ith Lumo of donor in the basis of 
# MOs of all atom
#--------------------------------------------
MOsize = len(fullMO1)
Psi = []

###### BRADEN NUMPY ######
olap   = np.array(olap).astype(float)
initMO = np.array(initMO)[:,1].astype(float)

for mo in range(MOsize):
    print(f"{mo} of {MOsize}")
    # < MO(all)_i | Psi(donor)_Lumo > is evaluated here
    
    # The following line is very slow... ~BMW
    MO = dftb.getPsi(mo+1,"../../2_NVT/output/nvt%s.xyz"%(i),"./MO/eigenvec.out")
    MO = np.array(MO)[:,1].astype(float) # BRADEN NUMPY

    # Save small time with einsum ~BMW
    #C = 0.0
    #for k in range(MOsize):
    #    for l in range(MOsize):
    #        C += MO[k] * initMO[l] * olap[l][k]
    C = np.einsum("k,l,lk->", MO, initMO, olap)
    print (round(C,5) , mo)
    Psi.append(str(C)+"\n")
print("WRITING THE WAVEFUNCTION")
fob = open("Psi.txt","w+")
fob.writelines(Psi)
os.chdir("../")
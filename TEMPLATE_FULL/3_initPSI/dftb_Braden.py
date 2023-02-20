import numpy as np
def getDonorGeom(filename,donorAtoms,ouputname="out.xyz"):
    import ase
    from ase.io import read , write
    fob = open(ouputname,"w+")
    fob.write(str(len(donorAtoms))+"\n")
    fob.write("Donor mol from %s\n"%(filename))
    mol  = read(filename,format='xyz') 
    for i in range(len(mol.positions)):
        if (i in donorAtoms):
            fob.write(mol.get_chemical_symbols()[i]+"\t"+"\t".join(map(str,mol.positions[i]))+"\n")
    fob.close()

def getDonorGeom_Braden(filename,donorAtoms,ouputname="out.xyz"):
    fob = open(ouputname,"w+")
    fob.write(str(len(donorAtoms))+"\n")
    fob.write("Donor mol from %s\n"%(filename))
    
    lines = open(filename,'r').readlines()
    symbols = []
    positions = []
    for count, line in enumerate(lines):
        t = line.split()
        if ( len(t) == 8 and (count-2) in donorAtoms ):
            symbols.append(t[0])
            positions.append(t[1:4])

    unique_symbols = list(set(symbols)) # atoms = list(set(mol.get_chemical_symbols()))

    if ( len(donorAtoms) != len(positions) ):
        print("Number of atoms found does not match requested in DONOR piece.")
        exit()

    for i in range(len(positions)):
        if ( i in np.array(donorAtoms) - np.array(donorAtoms[0]) ):
            fob.write(symbols[i]+"\t"+"\t".join(map(str,positions[i]))+"\t"+"\t".join(map(str,np.zeros((4))))+"\n")
    fob.close()
    print ("Unique DONOR Atoms: ", unique_symbols)

def xyz2dftb(filename):
    """
    Creates an sh file
    to convert a xyz to dftb input
    also returns atoms
    """
    # Get all Atoms
    import ase
    from ase.io import read 
    mol  = read(filename,format='xyz')
    atoms = list(set(mol.get_chemical_symbols()))
    positions = mol.positions
    symbols  = mol.get_chemical_symbols()
    output = []
    for i in range(len(positions)):
        thisSymbol = symbols[i]
        thisPosition = positions[i]
        for j in range(len(atoms)):
            if atoms[j] == thisSymbol:
               output.append( str(j+1)+"\t" + "\t".join(map(str,thisPosition))+"\n")  
    output = "".join(output)
    return atoms , output

def xyz2dftb_Braden(filename):
    """
    Creates an sh file
    to convert a xyz to dftb input
    also returns atoms
    """ 
    symbols = [ line.split()[0] for line in open(filename,'r').readlines() if len(line.split()) == 8 ] # symbols  = mol.get_chemical_symbols()
    unique_symbols = list(set(symbols)) # atoms = list(set(mol.get_chemical_symbols()))
    positions = [ line.split()[1:4] for line in open(filename,'r').readlines() if len(line.split()) == 8 ]
    
    output = []
    for i in range(len(positions)):
        thisSymbol = symbols[i]
        thisPosition = positions[i]
        for j in range(len(unique_symbols)):
            if unique_symbols[j] == thisSymbol:
               output.append( str(j+1)+"\t" + "\t".join(map(str,thisPosition))+"\n")  
    output = "".join(output)
    print ("Unique Atoms: ", unique_symbols)
    return unique_symbols , output


other = {'Fermi': 50, 'Charge': 0.0}
def dftbInputPsiEigen(filename, WriteHS ='No', other = other):
    """
    Create dftb_hst.in for optimization
    """
    #atoms , xyz = xyz2dftb(filename)
    atoms , xyz = xyz2dftb_Braden(filename)
    orbital = []
    # Orbital Construction
    for i in atoms:
        if i == "C":
            orbital.append("C = \"p\"")
        elif i == "H":
            orbital.append("H = \"s\"")
        elif i == "N":
            orbital.append("N = \"p\"")
        elif i == "O":
            orbital.append("O = \"p\"")
        elif i == "P":
            orbital.append("P = \"p\"")
        elif i == "F":
            orbital.append("F = \"p\"")
        elif i == "Se":
            orbital.append("Se = \"d\"")
        elif i == "Cd":
            orbital.append("Cd = \"d\"")
        elif i == "Cl":
            orbital.append("Cl = \"p\"")
        elif i == "Ti":
            orbital.append("Ti = \"d\"")
        else : 
            raise Exception('Atom not in my database!')

    print ("Orbital Momentum:", orbital)

    if float(other['Fermi']) == 0.0 :
        Driver = "dynamicsT0"
    else:
        Driver = "dynamics"
    angularMomentum = "\n\t".join(orbital)
    Atoms  = " ".join(["\"%s\""%(i) for i in  atoms])
    #SKF = "\"/scratch/bweight/software/FSSH_dftb_17.1/parameters_9-2-2021/slako/tiorg/tiorg-0-1/\""
    SKF = "\"/scratch/bweight/software/FSSH_dftb_17.1/parameters_9-2-2021/slako/matsci/matsci-0-3/\""
    Values = {'atomNames': Atoms,
            'skfLocation': SKF,
            'angularMomentum':angularMomentum,
            'xyz' : xyz,
            'WriteHS' :WriteHS,
            'Fermi': other['Fermi'],
            'Charge':other['Charge'],
            'Driver' : Driver}
    
    useTemplate('PsiEigen.hsd.tem', Values)


def useTemplate(templateFile, Values):
    """
    Use a template file 
    to create files
    """
    from string import Template
    filein = open( "./Template/"+templateFile )
    src = Template( filein.read() )
    out = src.safe_substitute(Values)
    templatename = templateFile.replace(".tem","")
    outName = open(templatename,"w+")
    outName.write(out)
    outName.close()

def checkJob(jobId,user="bweight"):
    """
    If Job is running returns True
    """
    import os
    SQ = os.popen("squeue -u %s"%(user)).read().split("\n")[1:]
    for i in SQ:
        try: 
            id = int(i.split()[0])
            if (id == jobId):
                return True
        except:
            pass
    return False

def makeId(position):
    thisid = "|".join(["{:+.3f}".format(i) for i in position])
    return thisid

def getPsi(ith,xyzFilename,filename = "eigenvec.out"):
    """
    get ith psi
    in AO
    ith start from 1
    """
    lines = open(filename,"r").readlines()
    readFlag = False
    for count, line in range( len(lines) ):
        t = line.split()
        if ( t[0] == 'Eigenvector:' and t[1] == f'{ith}' ):
            readFlag = True
        if ( t[0] == 'Eigenvector:' and t[1] == f'{ith+1}' ):
            readFlag = False
        if ( readFlag == True and len(t) in [3,5] ):
            


    for i in range(len(fob)):
        if fob[i].find("Eigenvector:") != -1:
            
            eigvec = fob[i].replace("Eigenvector:","").split()[0]
            if int(eigvec) == ith :
                start = i
            if int(eigvec)-1 == ith :
                end = i

    if (end != False) :
        psiDat = fob[start+1:end]
    else :
        psiDat = fob[start+1:]


    start = 1
    AO = []
    for i in range(1,len(psiDat)):
        
        
        if psiDat[i].strip() == "" :
            AO.append(psiDat[start:i])
            start = i+1
    psi = []
    for i in range(len(AO)):
        prefix = "".join(AO[i][0].split()[:2])
        hashId = getCoordinateHash(int(AO[i][0].split()[0]),xyzFilename)
        for j in range(len(AO[i])):
            AOname = prefix + AO[i][j].replace("\n","").split()[-3]
            AOcoeff = AO[i][j].replace("\n","").split()[-2]
            psi.append([AOname,AOcoeff,hashId])
    return psi

def getCoordinateHash(Pos,xyzFile) :   
    # Obtaining coordinate for hashing 
    import ase
    from ase.io import read , write
    mol = read(xyzFile,format="xyz")    
    hashId = makeId( mol.positions[Pos-1] )
    return hashId   

def expandPsi(Psi, biggerBasis):
    """
    get psi of Donor (in donor AO basis)
    and Expand it in Total AO basis
    note : 
    You can just use any Psi in all MO as your biggerBasis
    """
    newPsi = []
    for i in range(len(biggerBasis)):
        Coeff = '0.0'
        hashBig = biggerBasis[i][-1]
        for j in range(len(Psi)):
            hashPsi = Psi[j][-1]      
            if (hashPsi == hashBig) and (biggerBasis[i][0] == Psi[j][0]):
                Coeff = Psi[j][1]
                break
        
        newPsi.append([biggerBasis[i][0],Coeff,hashBig])
    return newPsi

def findHomo(detailedFile = "detailed.out"):
    """
    Finds the Homo from full basis
    """
    totalElectron = False
    fob = open(detailedFile,"r").readlines()
    for i in fob:
        if i.find("Nr. of electrons (up):") != -1:
            totalElectron = float(i.split()[-1])
    if (totalElectron%2) != 0:
        raise Exception('Number of electrons is odd !')
    return int(totalElectron/2)

def overlap(filename = "oversqr.dat"):
    """
    read the output file and get overlap
    """
    olap = open(filename).readlines()[5:]
    for i in range(len(olap)):
        olap[i] = olap[i].replace("\n","").split() 
    return olap
#def donorPsiInAllMO(donosPsi,AllMO):
def sbatch(filename):
    """
    Submit a job and get the job id returned
    """
    import os
    submit = os.popen("sbatch %s"%(filename)).read()
    subId = submit.split()[3].replace("\n","")
    return subId
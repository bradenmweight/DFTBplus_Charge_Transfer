import os
def xyz2dftb(filename):
    """
    convert a xyz to dftb input
    also returns atoms
    """
    # Get all Atoms
    import ase
    from ase.io import read 
    xyzFile = open(filename,"r").readlines()
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
               output.append( str(j+1) + "\t" + "\t".join(map(str,thisPosition))+"\n")  
    output = "".join(output)
    return atoms , output

def dftbInputOpt(filename,charge = 0.0, maxIteration = 100, Fermi = 50):
    """
    Create dftb_hst.in for optimization
    """
    orbital = []
    atoms , xyz = xyz2dftb(filename)
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
    
    angularMomentum = "\n\t".join(orbital)
    Atoms  = " ".join(["\"%s\""%(i) for i in  atoms])
    #SKF = "\"/scratch/bweight/software/FSSH_dftb_17.1/parameters/cdx-org-0-1/\""
    #SKF = "\"/scratch/bweight/software/FSSH_dftb_17.1/parameters_9-2-2021/slako/tiorg/tiorg-0-1/\""
    SKF = "\"/scratch/bweight/software/FSSH_dftb_17.1/parameters_9-2-2021/slako/matsci/matsci-0-3/\""
    Values = {'atomNames': Atoms,
            'skfLocation': SKF,
            'angularMomentum':angularMomentum,
            'xyz' : xyz,
            'charge' : charge,
            'maxIterations': maxIteration,
            'Fermi' : Fermi}
    
    useTemplate('dftb_in.hsd.tem', Values)
    

def useTemplate(templateFile, Values):
    """
    Use a template file 
    to create files
    """
    from string import Template
    filein = open( "./Template/"+templateFile )
    src = Template( filein.read() )
    out = src.safe_substitute(Values)
    outName = open(templateFile.replace(".tem",""),"w+")
    outName.write(out)
    outName.close()

def clean():
    os.system("rm -f my_ou*")
    os.system("rm -f test.xyz")
    os.system("rm -f *.sh")
    os.system("rm -f dftb_in.hsd")
    os.system("rm -f *.pyc")
    os.system("rm -f *.sbatch")

def getGeom(filename = "geom.out.xyz"):
    fob = open(filename,"r")
    traj = fob.readlines()
    natoms = int(traj[0].split()[0])
    nsteps = len(traj)/(natoms + 2 )
    fxyz = open("optimized.xyz","w+")
    fxyz.writelines(traj[int((natoms+2)*(nsteps - 1)):])
    fxyz.close()

def move(filename,dir):
    try:
        os.system("mv %s %s"%(filename,dir))
    except:
        pass

def moveOutput():
    os.system("rm -f my_*")
    try : 
        os.system("mkdir dftbOutput")
    except :
        pass
    move("results.tag","dftbOutput")
    move("geom.out.gen","dftbOutput")
    move("charges.bin","dftbOutput")
    move("output.log","dftbOutput")
    move("detailed.xml","dftbOutput")
    move("detailed.out","dftbOutput")
    move("band.out","dftbOutput")

def sbatch(filename):
    """
    Submit a job and get the job id returned
    """
    import os
    submit = os.popen("sbatch %s"%(filename)).read()
    subId = submit.split()[3].replace("\n","")
    return subId
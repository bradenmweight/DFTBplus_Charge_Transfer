import os
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


other = {'CouplingStrength': 1500, 'Fermi': 50, 'Charge': 0.0}

def dftbInputNVT(filename, temp="300",timeStep=0.5,steps=1000, other = other ):
    """
    Create dftb_hst.in for optimization
    """
    atoms , xyz = xyz2dftb(filename)
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
    if float(other['Fermi']) == 0.0 :
        Driver = "dynamicsT0"
    else:
        Driver = "dynamics"

    angularMomentum = "\n\t".join(orbital)
    Atoms  = " ".join(["\"%s\""%(i) for i in  atoms])
    #SKF = "\"/scratch/bweight/software/FSSH_dftb_17.1/parameters_9-2-2021/slako/tiorg/tiorg-0-1/\"" # No Ti-P parameters
    SKF = "\"/scratch/bweight/software/FSSH_dftb_17.1/parameters_9-2-2021/slako/matsci/matsci-0-3/\""
    Values = {'atomNames': Atoms,
            'skfLocation': SKF,
            'angularMomentum':angularMomentum,
            'temp' : temp,
            'steps': steps,
            'timeStep': timeStep,
            'xyz' : xyz,
            'CouplingStrength': other['CouplingStrength'],
            'Fermi': other['Fermi'],
            'Charge':other['Charge'],
            'Driver' : Driver}
    
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
    os.system("rm -f input.xyz")
    os.system("rm -f *.sh")
    os.system("rm -f dftb_in.hsd")
    os.system("rm -f *.pyc")
    os.system("rm -f *.sbatch")

def getGeom(filename = "geom.out.xyz",step = 10):
    import math
    fob = open(filename,"r")
    traj = fob.readlines()
    natoms = int(traj[0].split()[0])
    nsteps = len(traj)/(natoms + 2 )
    
    nskip = int(math.floor(nsteps / step))
    try: 
        os.system("mkdir output")
    except:
        pass 
    for i in range(1,step+1):
        fxyz = open("output/nvt%s.xyz"%(i),"w+")
        fxyz.writelines(traj[int((natoms+2)*(i*nskip - 1)):int((natoms+2)*(i*nskip))])
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
    move("md.out","dftbOutput")

def sbatch(filename):
    """
    Submit a job and get the job id returned
    """
    import os
    submit = os.popen("sbatch %s"%(filename)).read()
    subId = submit.split()[3].replace("\n","")
    return subId
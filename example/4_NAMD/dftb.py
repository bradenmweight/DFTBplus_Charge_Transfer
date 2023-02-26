
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
other = {'Fermi': 50, 'Charge': 0.0}
def dftbInputNamd(filename,timeStep=0.1, steps=10000,  other = other):
    """
    Create dftb_hst.in for optimization
    """
    atoms , xyz = xyz2dftb(filename)
    vel  = getVelocity(filename)
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
    #SKF = "\"/scratch/bweight/software/FSSH_dftb_17.1/parameters_9-2-2021/slako/tiorg/tiorg-0-1/\""
    SKF = "\"/scratch/bweight/software/FSSH_dftb_17.1/parameters_9-2-2021/slako/matsci/matsci-0-3/\""
    Values = {'atomNames': Atoms,
            'skfLocation': SKF,
            'angularMomentum':angularMomentum,
            'xyz' : xyz,
            'Fermi': other['Fermi'],
            'Charge':other['Charge'],
            'Driver' : Driver,
            'vel' : vel,
            'steps': steps,
            'timeStep': timeStep,}
    
    useTemplate('namd.hsd.tem', Values)


def getVelocity(filename):
    """
    reads velocity from xyz file
    vx vy and vz are in 5th, 6th and
    7th column
    """
    XYZ = open(filename,"r").readlines()[2:]
    vel = []
    for i in range(len(XYZ)):
        vel.append("\t".join(XYZ[i].replace("\n","").split()[4:7]))
    return "\n".join(vel) 

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
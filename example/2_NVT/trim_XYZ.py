import numpy as np

### Braden M. Weight ###

xyzFile = "geom.out.xyz"

lines = open(xyzFile,'r').readlines()
NAtoms = int(lines[0])
NSteps = len(lines) // (NAtoms+2)
coords = [] # np.zeros(( NSteps, NAtoms, 4 ))

# GET DATA
for count, line in enumerate( lines ):
    t = line.split()
    if ( len(t) == 1 and int(t[0]) == NAtoms ):
        tmp_step = []
        for at in range( NAtoms ):
            tmp_step.append( lines[count+2+at] )
        coords.append( tmp_step )

# PRINT DATA
dt = 1.0 # fs
NSkip = 20 # Write every {NSkip} geometries
outFILE = open( xyzFile+f"_Trimmed_{NSkip}.xyz" , 'w')
for step in range( 0, NSteps, NSkip ):
    print ( f"{step} of {NSteps}" )
    outFILE.write( f"{NAtoms}\n" )
    outFILE.write( f"Step = {step}, Time = {step*dt} fs\n" )
    for at in range( NAtoms ):
        outFILE.write( f"{coords[step][at]}" )


outFILE.close()



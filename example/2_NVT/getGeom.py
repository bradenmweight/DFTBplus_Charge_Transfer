import dftb
import sys
N = int(sys.argv[1])

dftb.getGeom("geom.out.xyz", N)
dftb.moveOutput()
dftb.clean()

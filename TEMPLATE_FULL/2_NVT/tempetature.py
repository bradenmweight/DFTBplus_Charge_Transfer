"""
Read the output file (output.log)
and generate a file containing temperature
with nvt steps.
"""
import sys
try :
    filename  = sys.argv[1]
except:
    try:
        filename  = "output.log"
        open(filename)
    except:
        filename  = "dftbOutput/output.log"
T = []
fob = open(filename).readlines()
step = 0
for i in fob :
    if i.find("MD Temperature") != -1:
        T.append(str(step) + "\t" + i.split()[-2]+ "\n")
        step += 1

t = open("temperature.txt","w+")
t.writelines(T)
t.close()

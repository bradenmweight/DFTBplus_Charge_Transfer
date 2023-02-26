import numpy as np
from matplotlib import pyplot as plt

def get_globals():
    global NTRAJ,NSTEPS
    NTRAJ = 50
    NSTEPS = 3000


def get_average(filename):
    
    print(f"Reading {filename}.")
    data = np.loadtxt(f'step1/{filename}')[:NSTEPS] * 0.0

    counter = 0
    for traj in range( 1,NTRAJ+1 ):
        try:
            data += np.loadtxt(f'step{traj}/{filename}')[:NSTEPS]
        except:
            print (f"\tFile no good. Skipping. Step = {traj}")
            continue
        counter += 1
    print (f"There were {counter} good trajectories of {NTRAJ}.")
    data /= counter
    np.savetxt(f'{filename}_average-{counter}.txt',data)
    
    return data[:,0], data[:,1:-1], counter
    
def plot_ad(time, pop, filename, number_good):
    NSTATES = len( pop[0,:] )
    for state in range( NSTATES ):
        plt.plot( time, pop[:,state], label=f'L+{state}' )
    plt.legend()
    plt.savefig(f'{filename}_average-{number_good}.jpg')
    plt.clf()

def plot_dia(time, pop, filename, number_good):
    plt.plot( time, pop[:,0], label=f'DONOR' )
    plt.plot( time, pop[:,1], label=f'ACCEPTOR' )
    plt.legend()
    plt.savefig(f'{filename}_average-{number_good}.jpg')
    plt.clf()


def main():
    get_globals()
    pop_files = ["adiabatic_pop.txt"]
    for filename in pop_files:
        time, pop, number_good = get_average(filename)
        plot_ad(time, pop, filename, number_good)

    pop_files = ["estimator1.txt","estimator2.txt","estimator3.txt"]
    for filename in pop_files:
        time, pop, number_good = get_average(filename)
        plot_dia(time, pop, filename, number_good)

if ( __name__ == "__main__" ):
    main()
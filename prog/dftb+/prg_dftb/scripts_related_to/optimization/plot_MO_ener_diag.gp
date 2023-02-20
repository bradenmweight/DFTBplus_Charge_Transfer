set term png size 1200,800 enhanced
set output 'MO_ener_of_ptb7_hpdi3_dftb.png' 
set title "trimer-PTB7 and hPDI3 MO energies DFTB (Blend E_{F} = -4.7177) \n" font "Serif, 25" tc rgbcolor "#000000" 
# Ranges for x and y
set yrange [-7:-1]
set xrange [0:4]

# Setting the margins (set the offsets for the labels based on these margins)

 set lmargin 15
 set tmargin 6
 set rmargin 24
 set bmargin 2

# Setting border

 set border lw 3 lc rgbcolor "#000000"  # all zeros is black color

# Setting the Axis labels and the title of the graph

 set xlabel font "Serif, 30" tc rgbcolor "#000000" offset 0, -1.0   #808080 is grey
 set ylabel font "Serif, 30" tc rgbcolor "#000000" offset -1.5, 0   #A00000 dark maroon

 set ylabel "Energy (eV)"
# set xlabel "DOS/PDOS"

# Setting the fonts of tic-labels

# set xtics out font "Serif, 20" nomirror tc rgbcolor "#000000" #offset 0, -3.0 # nomirror is required when 2 y-axis are different
unset xtics
 set ytics font "Serif, 20" nomirror tc rgbcolor "#000000"

# Setting the key for the legends
set key outside right
set key right top spacing 5 font "Serif, 20" tc rgbcolor "#000000" # spacing controls spacing between 2 legends

set style line 1 lt -1 lw 2 lc rgb "#009E9E"
set style line 2 lt -1 lw 2 lc rgb "#A00000"
set style line 3 lt -1 lw 2 lc rgb "blue"
#set style line 3 lt 0 lw 3 lc rgbcolor "black" #"orange"

# Setting Fermi-level
#set style arrow 1 nohead nofilled ls 4 #size screen 0.025,30,45 ls 4
#set arrow from -10.869161, graph 0 to -10.869161, graph 1  as 1

# Final command to plot the data 
p 'trimer_ptb7/eigvals.txt' u 1:2:3 w  xe ls 1 t "donor"    ,\
  'blend/eigvals.txt'       u 1:2:3 w  xe ls 2 t "blend" ,\
  'hPDI3/eigvals.txt'       u 1:2:3 w  xe ls 3 t "acceptor"


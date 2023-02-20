set term png size 1200,800 enhanced
#set output "dftb_ptb7_hPDI3_pdos.png"
set output "PDOS_of_ptb7_hPDI3.png" 

#======================
#set tmargin  5
#set bmargin  7
set lmargin 10
#set rmargin 5

#======================
set xrange[-1:1]
#set xrange[-4:4]
#set xrange [-6.7177:-2.7177]

#======================
set xlabel font "Serif, 30" tc rgbcolor "black" offset 0, -1.5
set ylabel font "Serif, 30" tc rgbcolor "black" offset -1.5, 0
set  title font "Serif, 30" tc rgbcolor "black"
set xlabel "E - E_{F} (eV)"
set ylabel "PDOS (arb. units)"
# set ylabel "Projected Density of States (arb. units)"

#set title "DFTB PDOS of Cd_{33}Se_{33} MB+"

#======================
# Setting border
#======================

 set border lw 3 lc rgbcolor "#000000"  # all zeros is black color

#======================
# Setting the fonts of tic-labels
#======================
 
 set xtics -1,0.1,1 out font "Serif, 20" nomirror tc rgbcolor "#000000" #offset 0, -3.0 # nomirror is required when 2 y-axis are different
# set xtics -4,1,4 out font "Serif, 20" nomirror tc rgbcolor "#000000" #offset 0, -3.0 # nomirror is required when 2 y-axis are different
# set xtics -6.7177,1,-2.7177 out font "Serif, 20" nomirror tc rgbcolor "#000000" 
 set ytics font "Serif, 20" nomirror tc rgbcolor "#000000"
unset ytics

#======================
# Setting the key for the legends
#======================
 
set key right top spacing 5 font "Serif, 20" tc rgbcolor "#000000" # spacing controls spacing between 2 legends
#unset key

set style line 1 lt -1 lw 2 lc rgb "#009E9E"
set style line 2 lt -1 lw 1 lc rgb "#A00000"
set style line 3 lt 0 lw 3 lc rgbcolor "black" #"orange"
set style line 4 lt -1 lw 4 lc rgb "blue"

#======================
# Setting Fermi-level
#======================
set style line 5 lw 2 lt 0 lc rgbcolor "black"
#set arrow from -4.7177, graph 0 to -4.7177, graph 1  as 1
set arrow from 0, graph 0 to 0, graph 1 nohead ls 5 lc rgb "black"

# Final command to plot the data from two text files absorption.txt and band_gap_all.dat 
#plot   "full.dos" u ($1):2 w l lw 4  t "Total",\
#       "ptb7.pdos" u ($1):2 w l lw 4  t "ptb7",#       "hPDI3.pdos" u ($1):2 w l lw 4  t "hPDI3"
plot   "full.dos" u ($1--4.7177):2 w l lw 4  t "Total",\
       "ptb7.pdos" u ($1--4.7177):2 w l lw 4  t "ptb7",       "hPDI3.pdos" u ($1--4.7177):2 w l lw 4  t "hPDI3"


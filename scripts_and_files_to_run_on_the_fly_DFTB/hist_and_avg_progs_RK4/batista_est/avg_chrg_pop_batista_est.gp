#
set term pngcairo size 850,800 enhanced # enhanced is required for latex symbols
set size square 

#set term pngcairo size 1200,800 enhanced # enhanced is required for latex symbols
set output "norm_chrg_pop_batista_est.png"

#set xrange [0:0.2]
set yrange [0:1.01]

set ytics 0, 0.1, 1.0

# Setting the margins (set the offsets for the labels based on these margins)
# set lmargin 15
# set tmargin 2
# set rmargin 15
 set bmargin 6

# Setting border
 set border lw 3 lc rgbcolor "#000000"  # all zeros is black color

# Setting the Axis labels and the title of the graph
 set xlabel font "Serif, 30" tc rgbcolor "#000000" offset 0, -1.0   #808080 is grey
 set ylabel font "Serif, 30" tc rgbcolor "#000000" offset -1.5, 0   #A00000 dark maroon

# Setting the fonts of tic-labels
 set xtics out font "Serif, 20" nomirror tc rgbcolor "#000000" #offset 0, -3.0 # nomirror is required when 2 y-axis are different
 set ytics font "Serif, 20" tc rgbcolor "#000000"

set grid

# Setting the key for the legends
#set key outside right top spacing 2 font "Serif, 12" tc rgbcolor "#000000" # spacing controls spacing between 2 legends
set key left top spacing 1 font "Serif, 12" tc rgbcolor "#000000" # spacing controls spacing between 2 legends

set xlabel "Time (ps)"
set ylabel "Charge Population (Est. 2)"

set style line 1 lt -1 lw 0.8
set style line 2 lt -1 lw 2.0 lc rgbcolor "#16A085"
set style line 3 lt -1 lw 2.0 lc rgbcolor "blue"

plot 'norm_chrg_pop_batista_est.txt' u ($1/1000):2 w l lw 5 t 'H2PC1',\
     'norm_chrg_pop_batista_est.txt' u ($1/1000):3 w l lw 5 t 'H2PC2',\
     'norm_chrg_pop_batista_est.txt' u ($1/1000):4 w l lw 5 t 'C60',\
     'norm_chrg_pop_batista_est.txt' u ($1/1000):($2+$3+$4) w l lw 5 t 'tot'

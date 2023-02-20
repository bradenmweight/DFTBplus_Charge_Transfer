#
set term pngcairo size 850,800 enhanced
set size square

#set term pngcairo size 1200,800 enhanced
set output "norm_hist_active_state_pop.png"

#set xrange [0:0.2]
#set yrange [0:1]

set ytics 0, 0.1, 1.0
#set xtics 0, 0.5, 5.0

# Setting the margins (set the offsets for the labels based on these margins)
# set lmargin 15
# set tmargin 2
# set rmargin 20
 set bmargin 6

# Setting border
 set border lw 3 lc rgbcolor "#000000"  # all zeros is black color

# Setting the Axis labels and the title of the graph
 set xlabel font "Serif, 30" tc rgbcolor "#000000" offset 0, -1.0   #808080 is grey
 set ylabel font "Serif, 30" tc rgbcolor "#000000" offset -1.5, 0   #A00000 dark maroon

# Setting the fonts of tic-labels
 set xtics out font "Serif, 20" nomirror tc rgbcolor "#000000" #offset 0, -3.0 # nomirror is required when 2 y-axis are different
 set ytics font "Serif, 20" tc rgbcolor "#000000"

# Setting the key for the legends
set key outside right
set key right top spacing 2 font "Serif, 12" tc rgbcolor "#000000" # spacing controls spacing between 2 legends
unset key

set xlabel "Time (ps)"
set ylabel "MO population (Surf. Hop.)" #Normalized active state pop"
#set ylabel "Adiabatic population" #Normalized active state pop"

p 'several_traj_norm_hist_active_state_pop.txt' u ($1/1000):2   w l lw 4 t '307th MO (LUMO)',\
  'several_traj_norm_hist_active_state_pop.txt' u ($1/1000):3   w l lw 4 t '308th MO',\
  'several_traj_norm_hist_active_state_pop.txt' u ($1/1000):4   w l lw 4 t '309th MO',\
  'several_traj_norm_hist_active_state_pop.txt' u ($1/1000):5   w l lw 4 t '310th MO',\
  'several_traj_norm_hist_active_state_pop.txt' u ($1/1000):6   w l lw 4 t '311th MO',\
  'several_traj_norm_hist_active_state_pop.txt' u ($1/1000):7   w l lw 4 t '312th MO',\
  'several_traj_norm_hist_active_state_pop.txt' u ($1/1000):8   w l lw 4 t '313th MO',\
  'several_traj_norm_hist_active_state_pop.txt' u ($1/1000):9   w l lw 4 t '314th MO',\
  'several_traj_norm_hist_active_state_pop.txt' u ($1/1000):10  w l lw 3 dt 4 t '315th MO',\
  'several_traj_norm_hist_active_state_pop.txt' u ($1/1000):11  w l lw 3 dt 4 t '316th MO',\
  'several_traj_norm_hist_active_state_pop.txt' u ($1/1000):($2+$3+$4+$5+$6+$7+$8+$9+$10+$11)  w l lw 4 t 'tot MO',\


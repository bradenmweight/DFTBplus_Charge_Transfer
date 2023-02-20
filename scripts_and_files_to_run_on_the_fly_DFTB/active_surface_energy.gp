#
set term pngcairo size 1200,800 enhanced font "/usr/share/fonts/liberation/LiberationSans-Regular.ttf"
set output "active_surface_energy.png"
set xrange [0:300.0]
#set yrange [0:1.01]
#set ytics 0, 0.1, 1.01
#set xtics 0, 0.5, 5.0

# Setting the margins (set the offsets for the labels based on these margins)

 set lmargin 15
 set tmargin 2
 set rmargin 20
 set bmargin 6

# Setting border

 set border lw 3 lc rgbcolor "#000000"  # all zeros is black color

# Setting the Axis labels and the title of the graph

# set xlabel font "30" tc rgbcolor "#000000" offset 0, -1.0   #808080 is grey
# set ylabel font "30" tc rgbcolor "#000000" offset -1.5, 0   #A00000 dark maroon

# Setting the fonts of tic-labels

# set xtics out font "20" nomirror tc rgbcolor "#000000" #offset 0, -3.0 # nomirror is required when 2 y-axis are different
# set ytics font "20" nomirror tc rgbcolor "#000000"

# Setting the key for the legends

set key outside right
#set key right top spacing 5 font "12" tc rgbcolor "#000000" # spacing controls spacing between 2 legends

set xlabel "Time (ps)"
set ylabel "Energy (eV)" #Normalized active state pop
set grid

p 'active_surface_energy.dat' u 1:2   w l lw 2 t '307th MO (LUMO)',\
  'active_surface_energy.dat' u 1:3   w l lw 2 t '308th MO',\
  'active_surface_energy.dat' u 1:4   w l lw 2 t '309th MO',\
  'active_surface_energy.dat' u 1:5   w l lw 2 t '310th MO',\
  'active_surface_energy.dat' u 1:6   w l lw 2 t '311th MO',\
  'active_surface_energy.dat' u 1:6   w l lw 2 t '311th MO',\
  'active_surface_energy.dat' u 1:7   w l lw 2 t '312th MO',\
  'active_surface_energy.dat' u 1:8   w l lw 2 t '313th MO',\
  'active_surface_energy.dat' u 1:9   w l lw 2 t '314th MO',\
  'active_surface_energy.dat' u 1:10  w l lw 2 t '315th MO',\
  'active_surface_energy.dat' u 1:11  w l lw 2 t '316th MO',\
  'active_surface_energy.dat' u 1:12:(1.5) w circles lc rgbcolor "red" fill solid border lt 8 t 'active State',\
 # 'active_surface_energy.dat' u 1:12  every 5 w p  pt 7 ps 2.0 lc rgbcolor "red" t 'active State',\

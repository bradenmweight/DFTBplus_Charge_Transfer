#!/bin/bash

main_dir=hist_and_avg_progs_RK4/
results_dir=results_RK4

mkdir $results_dir
#results_dir=results_hole_RK4

#------------------------------------------------------
current_dir=Bq_pop_hist/
file_name=get_hist_Bq_pop_many_trajs
cat > ${file_name}.input << EOF
10 10000 0.1
50
./
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50

1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 50
1, 2, 3, 5, 6, 9, 12, 13, 16, 18, 21, 23, 24, 25, 27, 28, 29


WRITE(6,*) "Enter number of states (nstates), total time-steps (n_tau) and time-step(tau)"
WRITE(6,*) "Enter number of nuclear trajectories"

WRITE(6,*) "Enter the inner directory name where txt files are stored in each nuclear trajectory"
WRITE(6,*) "like 'hole_dyn_HOMO_acceptor' or 'RK4_propg_1000_SH' etc."

WRITE(6,*) "Enter the successful traj numbers separated by commas (1, 3, 10, etc.)"
WRITE(6,*) "This feature is useful when some trajs fail"

echo "1, 13, 28" | sed 's/,/\n/g' | wc -l
EOF

cp ${main_dir}/${current_dir}/*.o ${main_dir}/${current_dir}/*.gp .
./${file_name}.o < ${file_name}.input
gnuplot ${file_name}.gp
rm ${file_name}.o ${file_name}.input
mv ${file_name}.gp *norm*txt avg*txt *png ${results_dir} 

#------------------------------------------------------
current_dir=active_state_hist/
file_name=get_hist_act_st_dftb_trajs
cat > ${file_name}.input << EOF
10 10000 0.1
50
./
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50

1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 50
1, 2, 3, 5, 6, 9, 12, 13, 16, 18, 21, 23, 24, 25, 27, 28, 29


WRITE(6,*) "Enter number of states (nstates), total time-steps (n_tau) and time-step(tau)"
WRITE(6,*) "Enter number of nuclear trajectories"

WRITE(6,*) "Enter the inner directory name where txt files are stored in each nuclear trajectory"
WRITE(6,*) "like 'hole_dyn_HOMO_acceptor' or 'RK4_propg_1000_SH' etc."

WRITE(6,*) "Enter the successful traj numbers separated by commas (1, 3, 10, etc.)"
WRITE(6,*) "This feature is useful when some trajs fail"

echo "1, 13, 28" | sed 's/,/\n/g' | wc -l
EOF

cp ${main_dir}/${current_dir}/*.o ${main_dir}/${current_dir}/*.gp .
./${file_name}.o < ${file_name}.input
gnuplot ${file_name}.gp
rm ${file_name}.o ${file_name}.input
mv ${file_name}.gp *norm*txt avg*txt *png ${results_dir} 

#------------------------------------------------------
current_dir=sbtnk_est_1/
file_name=avg_sbtnk_est_1
cat > ${file_name}.input << EOF
50 10000 3
./
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50

1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 50
1, 2, 3, 5, 6, 9, 12, 13, 16, 18, 21, 23, 24, 25, 27, 28, 29


WRITE(6,*) "Enter # nuclear trajectories, total time-steps (n_tau) and # fragments"

WRITE(6,*) "Enter the inner directory name where txt files are stored in each nuclear trajectory"
WRITE(6,*) "like 'hole_dyn_HOMO_acceptor' or 'RK4_propg_1000_SH' etc."

WRITE(6,*) "Enter the successful traj numbers separated by commas (1, 3, 10, etc.)"
WRITE(6,*) "This feature is useful when some trajs fail"

echo "1, 13, 28" | sed 's/,/\n/g' | wc -l
EOF

cp ${main_dir}/${current_dir}/*.o ${main_dir}/${current_dir}/*.gp .
./${file_name}.o < ${file_name}.input
gnuplot ${file_name}.gp
rm ${file_name}.o ${file_name}.input
mv ${file_name}.gp *norm*txt avg*txt *png ${results_dir} 

#------------------------------------------------------
current_dir=batista_est/
file_name=avg_chrg_pop_batista_est
cat > ${file_name}.input << EOF
50 10000 3
./
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50

1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 50
1, 2, 3, 5, 6, 9, 12, 13, 16, 18, 21, 23, 24, 25, 27, 28, 29

WRITE(6,*) "Enter # nuclear trajectories, total time-steps (n_tau) and # fragments"

WRITE(6,*) "Enter the inner directory name where txt files are stored in each nuclear trajectory"
WRITE(6,*) "like 'hole_dyn_HOMO_acceptor' or 'RK4_propg_1000_SH' etc."

WRITE(6,*) "Enter the successful traj numbers separated by commas (1, 3, 10, etc.)"
WRITE(6,*) "This feature is useful when some trajs fail"

echo "1, 13, 28" | sed 's/,/\n/g' | wc -l
EOF

cp ${main_dir}/${current_dir}/*.o ${main_dir}/${current_dir}/*.gp .
./${file_name}.o < ${file_name}.input
gnuplot ${file_name}.gp
rm ${file_name}.o ${file_name}.input
mv ${file_name}.gp *norm*txt avg*txt *png ${results_dir} 

#------------------------------------------------------
current_dir=sbtnk_est_3/
file_name=avg_sbtnk_est_3
cat > ${file_name}.input << EOF
50 10000 3
./
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50

1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 50
1, 2, 3, 5, 6, 9, 12, 13, 16, 18, 21, 23, 24, 25, 27, 28, 29

WRITE(6,*) "Enter # nuclear trajectories, total time-steps (n_tau) and # fragments"

WRITE(6,*) "Enter the inner directory name where txt files are stored in each nuclear trajectory"
WRITE(6,*) "like 'hole_dyn_HOMO_acceptor' or 'RK4_propg_1000_SH' etc."

WRITE(6,*) "Enter the successful traj numbers separated by commas (1, 3, 10, etc.)"
WRITE(6,*) "This feature is useful when some trajs fail"

echo "1, 13, 28" | sed 's/,/\n/g' | wc -l
EOF

cp ${main_dir}/${current_dir}/*.o ${main_dir}/${current_dir}/*.gp .
./${file_name}.o < ${file_name}.input
gnuplot ${file_name}.gp
rm ${file_name}.o ${file_name}.input
mv ${file_name}.gp *norm*txt avg*txt *png ${results_dir} 


PROGRAM get_hist_data
IMPLICIT NONE

INTEGER::i,j,k,n_tau
INTEGER::nNuclTraj,n_imp_Bqs
Integer, allocatable:: traj_num(:)

CHARACTER(20):: my_fmt, current_n_dftb, current_Bq
CHARACTER(200):: directory

REAL(KIND=8)::current_time, tau
REAL(KIND=8), ALLOCATABLE::hist_single(:,:),hist(:,:)

WRITE(6,*) "Enter number of imp Bqs (n_imp_Bqs),total time-steps (n_tau) and time-step(tau)"
READ(5,*) n_imp_Bqs, n_tau, tau 
WRITE(6,*)"n_imp_Bqs=", n_imp_Bqs, "n_tau=", n_tau , "and tau=", tau

WRITE(6,*) "Enter the number of nuclear trajectories" 
READ(5,*) nNuclTraj
WRITE(6,*)"nNuclTraj=", nNuclTraj

WRITE(6,*) "Enter the inner directory name where txt files are stored in each nuclear trajectory"
WRITE(6,*) "like 'hole_dyn_HOMO_acceptor' or 'RK4_propg_1000_SH' etc."
READ(5,*) directory
WRITE(6,*)"Entered inner directory name is =", directory

ALLOCATE(hist_single(n_tau,n_imp_Bqs),hist(n_tau,n_imp_Bqs),traj_num(nNuclTraj))

WRITE(6,*) "Enter the successful traj numbers separated by commas (1, 3, 10, etc.)"
WRITE(6,*) "This feature is useful when some trajs fail"
READ(5,*) traj_num(:)
WRITE(6,*)"traj_numbers=",traj_num

hist = 0 
DO I = 1, nNuclTraj
  WRITE(current_n_dftb, *)traj_num(I)
  OPEN(UNIT=11,FILE='./'//TRIM(adjustl(current_n_dftb))//'th_step/'//TRIM(adjustl(directory))//&
       &'/adiabatic_pop.txt',ACTION="READ")

  hist_single = 0
  DO K = 1, n_tau
    READ(11,*)current_time,hist_single(k,:)
    hist(K,:) = hist(K,:) + hist_single(k,:)
  END DO
  CLOSE(11)
  
END DO

OPEN(UNIT=12,FILE="./normalized_hist_Bq_pop.txt",form='formatted',ACTION="WRITE")
DO i = 1, n_tau
 WRITE(12,'(f10.2,10f7.3)')i*tau,hist(i,:)/REAL(nNuclTraj)
END DO
CLOSE(12)

END PROGRAM get_hist_data

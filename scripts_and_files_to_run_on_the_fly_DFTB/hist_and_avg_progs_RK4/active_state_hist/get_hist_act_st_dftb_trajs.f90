PROGRAM get_hist_data
IMPLICIT NONE
INTEGER::i,j,k,n_tau,nstates
INTEGER::nNuclTraj,n_hop_traj,ndigits,junk,istate
CHARACTER(20):: my_fmt, current_n_dftb, current_n_hop
CHARACTER(200):: directory 
REAL(KIND=8)::current_time,tau
REAL(KIND=8), ALLOCATABLE::hist_single(:,:),hist(:,:)
Integer, allocatable:: traj_num(:)

WRITE(6,*) "Enter number of states (nstates), total time-steps (n_tau) and time-step(tau)"
READ(5,*) nstates, n_tau, tau
WRITE(6,*)"nstates=", nstates, "n_tau=", n_tau, "and tau=", tau 

WRITE(6,*) "Enter number of nuclear trajectories"
READ(5,*) nNuclTraj
WRITE(6,*)"nNuclTraj=", nNuclTraj

WRITE(6,*) "Enter the inner directory name where txt files are stored in each nuclear trajectory"
WRITE(6,*) "like 'hole_dyn_HOMO_acceptor' or 'RK4_propg_1000_SH' etc."
READ(5,*) directory 
WRITE(6,*)"Entered inner directory name is =", directory

ALLOCATE(hist(n_tau,nstates),hist_single(n_tau,nstates),traj_num(nNuclTraj))
!OPEN(111, FILE='./eigvals_dir/eigvals_'//TRIM(current_t)//'.dat')

WRITE(6,*) "Enter the successful traj numbers separated by commas (1, 3, 10, etc.)"
WRITE(6,*) "This feature is useful when some trajs fail"
READ(5,*) traj_num(:)
WRITE(6,*)"traj_numbers=",traj_num

hist = 0 
DO I = 1, nNuclTraj

  WRITE(current_n_dftb, *)traj_num(I)
  OPEN(UNIT=11,FILE='./'//TRIM(adjustl(current_n_dftb))//'th_step/'//TRIM(adjustl(directory))//&
       &'/FSSH_adiabatic_pop.txt',ACTION="READ")

  hist_single = 0 
  DO K = 1, n_tau
    READ(11,*)current_time,(hist_single(k,j),j=1,nstates)
    hist(K,:) = hist(K,:) + hist_single(k,:)
  END DO
  CLOSE(11)

END DO

OPEN(UNIT=12,FILE="./several_traj_norm_hist_active_state_pop.txt",ACTION="WRITE")
DO i = 1, n_tau
 WRITE(12,'(11f10.4)')i*tau,(REAL(hist(i,j))/REAL(nNuclTraj),j=1,nstates)
END DO
CLOSE(12)

END PROGRAM get_hist_data


!      IF     (istate == 1) then
!       hist(i,1)=hist(i,1) + 1
!      ELSEIF (istate == 2) then
!       hist(i,2)=hist(i,2) + 1
!      ELSEIF (istate == 3) then
!       hist(i,3)=hist(i,3) + 1
!      ELSEIF (istate == 4) then
!       hist(i,4)=hist(i,4) + 1
!      ELSEIF (istate == 5) then
!       hist(i,5)=hist(i,5) + 1
!      ELSEIF (istate == 6) then
!       hist(i,6)=hist(i,6) + 1
!      ELSEIF (istate == 7) then
!       hist(i,7)=hist(i,7) + 1
!      ELSEIF (istate == 8) then
!       hist(i,8)=hist(i,8) + 1
!      ELSEIF (istate == 9) then
!       hist(i,9)=hist(i,9) + 1
!      ELSEIF (istate == 10) then
!       hist(i,10)=hist(i,10) + 1
!      END IF

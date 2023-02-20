PROGRAM average_mqc
IMPLICIT NONE
INTEGER :: i, j, k, l
INTEGER :: n_tau, n_frags, nNuclTraj
Integer, allocatable:: traj_num(:)

REAL(KIND=8),allocatable :: t(:), mqc(:,:), avg_mqc(:,:)

CHARACTER(20) :: my_fmt
CHARACTER(20) :: current_n_dftb, current_n_hop
CHARACTER(200):: directory

WRITE(*,*) "ENTER # nuclear trajectories, # trajectory steps and # fragments"
READ(*,*) nNuclTraj, n_tau, n_frags
WRITE(6,*)"nNuclTraj=", nNuclTraj,"no.of trajectory steps=", n_tau, "no. of frags=", n_frags

WRITE(6,*) "Enter the inner directory name where txt files are stored in each nuclear trajectory"
WRITE(6,*) "like 'hole_dyn_HOMO_acceptor' or 'RK4_propg_1000_SH' etc."
READ(5,*) directory
WRITE(6,*)"Entered inner directory name is =", directory

ALLOCATE(t(n_tau),mqc(n_tau,n_frags+1),avg_mqc(n_tau,n_frags+1),traj_num(nNuclTraj))

WRITE(6,*) "Enter the successful traj numbers separated by commas (1, 3, 10, etc.)"
WRITE(6,*) "This feature is useful when some trajs fail"
READ(5,*) traj_num(:)
WRITE(6,*)"traj_numbers=",traj_num

WRITE(my_fmt,'(a, i3, a)')  '(', n_frags+2, 'f15.10)'

mqc=0.0d0
avg_mqc=0.0d0
DO I = 1, nNuclTraj
  WRITE(current_n_dftb, *)traj_num(I)
  OPEN(UNIT=111,FILE='./'//TRIM(adjustl(current_n_dftb))//'th_step/'//TRIM(adjustl(directory))//&
       &'/estimator3.txt',ACTION="READ")
  DO K = 1, n_tau
    READ(111,*)t(K), (mqc(K,L),L=1,n_frags+1)
    avg_mqc(K,:) = avg_mqc(K,:) + mqc(K,:) 
  END DO
  CLOSE(111)

END DO

OPEN(UNIT=222,FILE="./norm_sbtnk_est_3.txt",ACTION="WRITE")
DO j=1,n_tau
 WRITE(222, my_fmt) t(j),(avg_mqc(j,:)/REAL(nNuclTraj))
END DO
CLOSE(222)

END PROGRAM average_mqc

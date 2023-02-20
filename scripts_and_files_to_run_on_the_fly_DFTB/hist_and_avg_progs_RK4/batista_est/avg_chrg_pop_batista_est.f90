PROGRAM average_surv
IMPLICIT NONE
CHARACTER(20) :: current_n_dftb, my_fmt1
CHARACTER(200):: directory

REAL(KIND=8),allocatable :: t(:),surv(:,:,:),avg_surv(:,:)

INTEGER:: i,j,traj_steps, nNuclTraj, frags
Integer, allocatable:: traj_num(:)

WRITE(*,*) "ENTER  # sampling conditions, # trajectory steps and # fragments"
READ(*,*)  nNuclTraj, traj_steps, frags

WRITE(6,*) "Enter the inner directory name where txt files are stored in each nuclear trajectory"
WRITE(6,*) "like 'hole_dyn_HOMO_acceptor' or 'RK4_propg_1000_SH' etc."
READ(5,*) directory
WRITE(6,*)"Entered inner directory name is =", directory

ALLOCATE(t(traj_steps),surv(nNuclTraj,traj_steps,frags),avg_surv(traj_steps,frags),traj_num(nNuclTraj))

WRITE(6,*) "Enter the successful traj numbers separated by commas (1, 3, 10, etc.)"
WRITE(6,*) "This feature is useful when some trajs fail"
READ(5,*) traj_num(:)
WRITE(6,*)"traj_numbers=",traj_num

WRITE(my_fmt1,'(a, i3, a)')  '(', frags+2, 'f15.10)'

avg_surv=0.0d0
DO I = 1, nNuclTraj
  WRITE(current_n_dftb, *)traj_num(I)
  OPEN(UNIT=111,FILE='./'//TRIM(adjustl(current_n_dftb))//'th_step/'//TRIM(adjustl(directory))//&
       &'/estimator2.txt',ACTION='read')

  READ(111,*) ! read the first line
  DO j=1,traj_steps
    READ(111,*)t(j),surv(i,j,:)
    avg_surv(j,:)=avg_surv(j,:)+surv(i,j,:)
  END DO
END DO
CLOSE(111)

OPEN(UNIT=222,FILE="./norm_chrg_pop_batista_est.txt",form='formatted',ACTION="WRITE")
DO j=1,traj_steps
 WRITE(222, my_fmt1) t(j),(avg_surv(j,:)/nNuclTraj)
END DO
END PROGRAM average_surv

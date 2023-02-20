PROGRAM ao_to_mo
!(nAOs,nMOs,ao,S,Qq_i_alpha,C)
IMPLICIT NONE

! This program is to get C(q,t) from B_j_beta(t).
! Cq's are the coefficients to represent LUMO in MO basis (remember that LUMO is evolving with time)
! B_j_beta's are the coefficients to represent the time evolved wfn (here, LUMO) in AO basis
! Read Prof. Batista's JACS 2003, 125, 7989-7997 paper on TiO2 + Catechol.
! This program is inspired from dyanmics package of Prof. Batista's group.

! INTERFACE variables
INTEGER :: nAOs, nMOs, i, j
INTEGER:: j_beta, i_alpha, q
REAL(KIND=8), DIMENSION(:,:), ALLOCATABLE :: S, Qq_i_alpha ! S=overlap, Q = AO coefficients of each eigvec q
COMPLEX(KIND=8), DIMENSION(:), ALLOCATABLE :: temp_ao, ao, C ! B_j_beta(t)'s in Batista's work

!===========================================
! Read the Energies at t=0 and B_q_zero
!===========================================
OPEN(UNIT=100, FILE='input_ao_to_mo.txt', ACTION="READ")
READ(100, *) nAOs
nMOs=nAOs

ALLOCATE(S(nAOs,nAOs), Qq_i_alpha(nMOs,nMOs))
ALLOCATE(temp_ao(1:nAOs), ao(1:nAOs), C(1:nAOs))
!--------------------

!OPEN(111, FILE='./eigvals_zero.out', ACTION="READ")
OPEN(UNIT=222, FILE='./LUMO_ads_in_full_basis.txt', ACTION="READ")
OPEN(UNIT=333, FILE='./eigvecs_zero.out', ACTION="READ")
OPEN(UNIT=444, FILE='./B_q_zero.txt', ACTION="WRITE")
OPEN(UNIT=555, FILE='./overlap_zero.dat', ACTION="READ")
!--------------------

!DO q=1,nImpMOs
DO q=1,nMOs
 DO i=1,nAOs
  READ(333,*) Qq_i_alpha(q,i)
 END DO
END DO
CLOSE(333)

DO j=1,nAOs
! READ(111,*) old_E(j)
 READ(222,*) ao(j)
 READ(555,*) (S(j,i), i=1,nAOs)
END DO

!CLOSE(111)
CLOSE(222)
CLOSE(555)
!--------------------

!Local variables
! 3 do loops have been divided to two separate 2 do loops. temp_ao is used for this
! Further, vectorization is used for both of these loops to increase performance
!--------------------
temp_ao= (0.0d0,0.0d0)
C=(0.0d0,0.0d0)

DO j_beta=1,nAOs 
  temp_ao(:) = temp_ao(:) + ao(j_beta)*(S(:,j_beta))
END DO

DO i_alpha=1,nAOs
  C(:) = C(:) + (Qq_i_alpha(:,i_alpha))*temp_ao(i_alpha) ! Qq_i_alpha(i_alpha) gives the dependency on 'q' for C
END DO
!--------------------

DO i_alpha=1,nAOs
  WRITE(444,'(f15.10,f15.10)') C(i_alpha)
END DO

END PROGRAM ao_to_mo


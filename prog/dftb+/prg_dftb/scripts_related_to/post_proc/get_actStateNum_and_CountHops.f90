program get_actState_NUm_and_count_hops
implicit none

! '10' is the number of FSSH trajectories for which we
! are printing active State energies. So, actStateEner(10).

integer:: i,j,nSurf,nTau,hop(10)
real(kind=8):: actStateEner(10)
integer, allocatable :: actStateNum(:,:)
real(kind=8),allocatable:: ener(:),time(:)

write(*,*)"Enter nImpMOs, nTau"
read(*,*)nSurf, nTau
allocate(ener(nSurf), actStateNum(10,nTau),time(nTau))

open(unit=10,file='active_surface_energy.dat',action='read')
open(unit=11,file='active_surface_number.dat',action='readwrite')

do j=1,nTau
 read(10,*) time(j), ener(:),actStateEner(:)
 do i=1,10
  actStateNum(i,j) = minloc(abs(ener - actStateEner(i)), 1)
 end do
 write(11,'(f12.6,10i4)') time(j), actStateNum(:,j)
end do

hop=0
do j=2,nTau
 do i=1,10
  if(.not. (actStateNum(i,j) == actStateNum(i,j-1))) then
    hop(i) = hop(i) + 1
  end if
 end do
end do

write(*,*) "Number of hops for each trajectory is:"
write(*,'(10I4)')  hop

end program get_actState_NUm_and_count_hops

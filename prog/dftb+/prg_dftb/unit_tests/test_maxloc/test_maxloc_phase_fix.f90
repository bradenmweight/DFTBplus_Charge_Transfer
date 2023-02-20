program test
  implicit none
  real(kind=8) :: overlap(10,10)
  integer :: i,j,k

  open(unit=10,file='MOOverlap.txt',action='read')

  do k=1,2000 ! steps
    do i=1,10
      read(10,*) overlap(:,i)
      write(11,*) maxloc(abs(overlap(:,i))), maxval(abs(overlap(:,i))) 
    end do
    read(10,*)
  end do

end program test


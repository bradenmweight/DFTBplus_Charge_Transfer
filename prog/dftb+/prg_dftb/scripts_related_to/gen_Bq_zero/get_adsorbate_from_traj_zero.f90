PROGRAM write_LUMO_in_full_basis
IMPLICIT NONE
INTEGER:: i, j 
INTEGER, ALLOCATABLE:: adsrob_atom_num(:)
INTEGER:: natoms, nadsorb_atoms
CHARACTER(LEN=5), ALLOCATABLE::atom_name(:)
REAL(KIND=8), ALLOCATABLE :: x_coor(:), y_coor(:), z_coor(:)

OPEN(UNIT=10,FILE="traj_zero",ACTION='READ')
OPEN(UNIT=11,FILE="input_get_adsorbate.txt",ACTION='READ')

READ(10,*)natoms
READ(10,*)
ALLOCATE(atom_name(natoms),x_coor(natoms), y_coor(natoms), z_coor(natoms))

DO i = 1, natoms
  READ(10,*) atom_name(i), x_coor(i), y_coor(i), z_coor(i)
END DO
CLOSE(10)

READ(11,*)nadsorb_atoms
ALLOCATE(adsrob_atom_num(nadsorb_atoms))
DO i = 1, nadsorb_atoms
  READ(11,*) adsrob_atom_num(i)
END DO
CLOSE(11)

OPEN(UNIT=20,FILE="adsorbate.xyz",ACTION='WRITE')
WRITE(20,*) nadsorb_atoms
WRITE(20,*) 
DO i = 1, nadsorb_atoms
   j = adsrob_atom_num(i)
   WRITE(20,'(a5,3f12.6)')atom_name(j), x_coor(j), y_coor(j), z_coor(j) 
END DO

ENDPROGRAM write_LUMO_in_full_basis

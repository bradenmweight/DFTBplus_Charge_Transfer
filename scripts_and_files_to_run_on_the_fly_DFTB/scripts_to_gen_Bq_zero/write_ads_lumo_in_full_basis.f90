PROGRAM convert_ads_to_sys_basis 
IMPLICIT NONE
INTEGER:: i, j, k
INTEGER, ALLOCATABLE:: adsrob_atom_num(:), norb_atom(:)
INTEGER:: natoms, nadsorb_atoms, tot_orb, norbs
CHARACTER(LEN=5), ALLOCATABLE::atom_name(:)
REAL(KIND=8), ALLOCATABLE :: x_coor(:), y_coor(:), z_coor(:)
REAL(KIND=8), ALLOCATABLE :: LUMO_full_basis(:)

OPEN(UNIT=10,FILE="traj_zero",ACTION='READ')
OPEN(UNIT=11,FILE="input_get_adsorbate.txt",ACTION='READ')
OPEN(UNIT=12,FILE="LUMO_adsorbate.txt",ACTION='READ')
OPEN(UNIT=20,FILE="LUMO_ads_in_full_basis.txt",ACTION='WRITE')

!----------------
READ(10,*)natoms
READ(10,*)
ALLOCATE(atom_name(natoms),x_coor(natoms), y_coor(natoms), z_coor(natoms))
ALLOCATE(norb_atom(0:natoms))
DO i = 1, natoms
  READ(10,*) atom_name(i), x_coor(i), y_coor(i), z_coor(i)
END DO
CLOSE(10)

!----------------
READ(11,*)nadsorb_atoms
ALLOCATE(adsrob_atom_num(nadsorb_atoms))
DO i = 1, nadsorb_atoms
  READ(11,*) adsrob_atom_num(i)
END DO
CLOSE(11)

WRITE(21,*) "'Atom name'    'Orbitals till this atom'"
!----------------
norb_atom=0
DO i = 1, natoms

  IF (atom_name(i) == "H") then
    norbs = 1
  ELSEIF (atom_name(i) == "Li" .OR. atom_name(i) == "B"  .OR. & 
        & atom_name(i) == "C"  .OR. atom_name(i) == "N"  .OR. &
        & atom_name(i) == "O"  .OR. atom_name(i) == "F"  .OR. &
        & atom_name(i) == "Na" .OR. atom_name(i) == "Mg"  .OR. &
        & atom_name(i) == "K"  .OR. atom_name(i) == "Ca") then 
!        & atom_name(i) == "Ca" .OR. atom_name(i) == "Mg"  .OR. &
    norbs = 4
  ELSEIF (atom_name(i) == "S"  .OR. atom_name(i) == "Se" .OR. &
        & atom_name(i) == "P" .OR. atom_name(i) == "Cl" .OR. &
        & atom_name(i) == "Br" .OR. atom_name(i) == "I" .OR. &
        & atom_name(i) == "Zn" .OR. atom_name(i) == "Cd") then
    norbs = 9
  ELSE
    WRITE(*, *) "This atom type is not known. Add this in your program."
    WRITE(*, *) "OR CHECK your input. There is something creepy"
    EXIT
  END IF
  norb_atom(i) = norb_atom(i-1) + norbs
  write(21,*)atom_name(i), norb_atom (i)
END DO
!----------------

tot_orb = norb_atom(natoms)
ALLOCATE(LUMO_full_basis(tot_orb))
LUMO_full_basis=0.0d0
DO i = 1, nadsorb_atoms
   j = adsrob_atom_num(i)
   write(22,*) i, j
   DO k=norb_atom(j-1)+1,norb_atom(j)
   write(22,*) k 
     READ(12,*) LUMO_full_basis(k)
   END DO
END DO
!----------------

DO i = 1, tot_orb
   WRITE(20, '(f12.6)')LUMO_full_basis(i)
END DO
!----------------

END PROGRAM convert_ads_to_sys_basis 

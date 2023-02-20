#!/bin/bash
for i in $@
do
  cat ${i} | awk '{if(NR>2) print $1, $2, $3, $4}' > input.xyz
  sed -i 's/H/1/g' input.xyz
  sed -i 's/C/2/g' input.xyz
  sed -i 's/N/3/g' input.xyz
#  sed -i 's/F/4/g' input.xyz
#  sed -i 's/S/5/g' input.xyz
#  sed -i 's/O/6/g' input.xyz
done


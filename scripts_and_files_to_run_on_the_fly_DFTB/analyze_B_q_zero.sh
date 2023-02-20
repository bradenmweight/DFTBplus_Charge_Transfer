#!/bin/bash
for i in $(seq 1 50);do
  var1=$(grep -n "0\.9" ${i}th_step/B_q_zero.txt)
  echo $var1 "${i}th_step"
done

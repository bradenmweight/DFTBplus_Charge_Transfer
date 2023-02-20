#!/bin/bash
for i in $(ls -d */); do cd ${i}; var1=$(ls *gp); cp ../../results_RK4/${var1} . ; cd ../;done

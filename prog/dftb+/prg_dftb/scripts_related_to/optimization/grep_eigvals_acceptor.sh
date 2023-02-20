#!/bin/bash
awk ' $1 ~ /Eigenvalues/ && $2 ~ /eV/, $1 ~/^$/' detailed.out | head -n-1 | tail -n+2 | awk '{print 3, $1, 0.2}'> eigvals.txt


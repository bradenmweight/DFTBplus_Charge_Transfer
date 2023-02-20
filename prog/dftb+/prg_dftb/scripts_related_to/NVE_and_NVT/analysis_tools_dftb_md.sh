grep "Total MD Energy:" output.log | awk '{print $4}' | xmgrace -pipe
grep "MD Temperature::" output.log | awk '{print $(NF-1)}' | xmgrace -pipe

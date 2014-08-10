#!/bin/bash

. var_common.gts

rm -rf eranges.dat

read -p "How many logarithmic energy bins do you want to obtain? " bins_number
step=`awk "BEGIN{print ($par_emax/$par_emin)^(1.0/$bins_number)}"`

for ((i=0; i<=$bins_number; i++))
do
  ebound=`printf "%0.f" $(echo "$par_emin*($step^$i)" | bc)`
  [[ $ebound -lt $par_emin ]] && ebound=$par_emin
  [[ $ebound -gt $par_emax ]] && ebound=$par_emax
  echo $ebound >> eranges.dat
done

#!/bin/bash

. var_common.gts

rm -rf eranges.dat

read -p "How many logarithmic energy bins do you want to obtain? " bins_number
step=`awk 'BEGIN{printf("%f", ('$par_emax'/'$par_emin')^(1.0/'$bins_number'))}'`

for ((i=0; i<=$bins_number; i++))
do
  ebound=`printf "%0.f" $(echo "$par_emin*($step^$i)" | bc)`
  [[ $i -eq 0 ]] && ebound=$par_emin
  [[ $i -eq $bins_number ]] && ebound=$par_emax
  echo $ebound >> eranges.dat
done

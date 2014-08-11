#!/bin/bash

. var_common.gts

time=`ftlist $file_filtered K | grep TST | head -n2 | awk '{print $3}' | tr -d '\n'`
par_tmin=`echo $time | cut -d . -f 1`
par_tmax=`echo $time | cut -d . -f 2`

rm -rf tranges.dat

read -p "How many linear time bins do you want to obtain? " bins_number
step=`awk 'BEGIN{printf("%f", ('$par_tmax' - '$par_tmin') / '$bins_number')}'`

for ((i=0; i<=$bins_number; i++))
do
  tbound=`printf "%0.f" $(echo "$par_tmin + $step * $i" | bc)`
  [[ $i -eq 0 ]] && tbound=$par_tmin
  [[ $i -eq $bins_number ]] && tbound=$par_tmax
  echo $tbound >> tranges.dat
done

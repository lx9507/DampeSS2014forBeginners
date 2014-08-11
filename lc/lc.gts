#!/bin/bash

#ln -sf ../unbinned/var_common.gts var_common.gts
. var_common.gts

file_filtered_tbin=${par_srcname}.fits
dir_results=results
rm -rf $dir_results && mkdir $dir_results
file_model_initial=model_input_lc.xml

echo '#Tmin Tmax Flux FluxErr TS' > flux_tmp

cat tranges.dat | sed '/^#/d' | sed '1!H;x;1d' | sed 'N;s/\n/ /' |
while read par_tmin par_tmax
do
  [[ "x$flag" = "x0" ]] && break
  flag=1

  file_model_1st=$dir_results/model_1st_${par_tmin}_$par_tmax.xml
  file_model_final=$dir_results/model_final_${par_tmin}_$par_tmax.xml
  file_model_ul=$dir_results/model_ul_${par_tmin}_$par_tmax.xml
  file_result_1st=$dir_results/result_1st_${par_tmin}_$par_tmax.dat
  file_result_final=$dir_results/result_final_${par_tmin}_$par_tmax.dat

  gtselect infile=$file_filtered outfile=$file_filtered_tbin ra=INDEF dec=INDEF rad=INDEF tmin=$par_tmin tmax=$par_tmax emin=$par_emin emax=$par_emax zmax=100 &&
  gtmktime scfile=$file_spacecraft filter="(DATA_QUAL==1)&&(LAT_CONFIG==1)&&ABS(ROCK_ANGLE)<52" roicut=yes evfile=$file_filtered_tbin outfile=$file_filtered_gti &&
  gtltcube evfile=$file_filtered_gti scfile=$file_spacecraft outfile=$file_ltcube dcostheta=0.025 binsz=1 &&
  #python gtltcube_mp.py 5 $file_spacecraft $file_filtered_gti $file_ltcube --zmax 100 &&
  gtexpmap evfile=$file_filtered_gti scfile=$file_spacecraft expcube=$file_ltcube outfile=$file_expmap irfs=$par_irfs srcrad=$par_srcrad nlong=$par_nlong nlat=$par_nlat nenergies=$par_nenergies &&
  #python gtexpmap_mp.py $par_nlong $par_nlat 4 4 $file_spacecraft $file_filtered_gti $file_ltcube $par_irfs $par_srcrad $par_nenergies $file_expmap &&
  #gtdiffrsp evfile=$file_filtered_gti scfile=$file_spacecraft srcmdl=$file_model_intitial irfs=$par_irfs &&
  gtlike irfs=$par_irfs expcube=$file_ltcube srcmdl=$file_model_initial statistic=UNBINNED optimizer=DRMNFB evfile=$file_filtered_gti scfile=$file_spacecraft expmap=$file_expmap sfile=$file_model_1st results=$file_result_1st &&
  gtlike irfs=$par_irfs expcube=$file_ltcube srcmdl=$file_model_1st statistic=UNBINNED optimizer=NEWMINUIT evfile=$file_filtered_gti scfile=$file_spacecraft expmap=$file_expmap sfile=$file_model_final results=$file_result_final &&

  flag=1 || flag=0

  [[ "x$flag" = "x0" ]] && continue

  flux=`egrep "$par_srcname|Flux" $file_result_final | grep $par_srcname -A 1 | grep Flux | cut -d "'" -f 4 | cut -d ' ' -f 1`
  fluxErr=`egrep "$par_srcname|Flux" $file_result_final | grep $par_srcname -A 1 | grep Flux | cut -d "'" -f 4 | cut -d ' ' -f 3`
  Npred=`egrep "$par_srcname|Npred" $file_result_final | grep $par_srcname -A 1 | grep Npred | cut -d "'" -f 4`
  TS=`egrep "$par_srcname|TS" $file_result_final | grep $par_srcname -A 1 | grep TS | cut -d "'" -f 4`
  if [ `awk -v f=$flux -v fe=$fluxErr -v Np=$Npred 'BEGIN{if(f/fe > sqrt(Np)) print 0; else print 1}'` = 0 ]
  then
    fluxErr=`awk -v f=$flux -v Np=$Npred 'BEGIN{print f / sqrt(Np)}'`
  fi

  if [ `awk -v ts=$TS "BEGIN{if(ts > 4) print 1; else print 0}"` = 1 ]
  then
    echo "$par_tmin $par_tmax $flux $fluxErr $TS" >> flux_tmp
  else
    echo "#$par_tmin $par_tmax $flux $fluxErr $TS" >> flux_tmp &&
    # fix all parameters of the target source in the model file used by the Upper Limit calculation.
    awk 'BEGIN{tag=0} /^.*'$par_srcname'/{tag=1}{if(tag==1) sub(/free=\"1\"/, "free=\"0\""); print}/^.*<\/source>$/{tag=0}' $file_model_final > $file_model_ul &&
    python ul.py ul.dat $par_srcname $par_irfs $par_emin $par_emax $file_filtered_gti $file_spacecraft $file_expmap $file_ltcube $file_model_ul &&
    ul=`cat ul.dat | sed 's/^\[\([^ ]*\).*$/\1/'` &&
    echo "$par_tmin $par_tmax $ul 0 -1e9" >> flux_tmp &&
    rm -rf ul.dat &&
    flag=1 || flag=0
  fi
done

column -t flux_tmp > flux.dat
rm -rf flux_tmp

python plt_gen.py $par_srcname
gnuplot lc.plt

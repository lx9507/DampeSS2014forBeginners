#!/bin/bash

ln -sf ../binned/var_common.gts var_common.gts
. var_common.gts

ln -sf ../binned/$file_filtered_gti $file_filtered_gti
ln -sf ../binned/$file_ltcube $file_ltcube

dir_results=results
rm -rf $dir_results && mkdir $dir_results
file_model_initial=model_input_sed.xml

par_enumbins=5

echo '#Emin Emax Flux FluxErr TS' > flux_tmp

cat eranges.dat | sed '/^#/d' | sed '1!H;x;1d' | sed 'N;s/\n/ /' |
while read par_emin par_emax
do
  #[[ "x$flag" = "x0" ]] && break
  flag=1

  par_emin_g=`awk "BEGIN{print $par_emin/1000}"`
  par_emax_g=`awk "BEGIN{print $par_emax/1000}"`
  file_model_1st=$dir_results/model_1st_${par_emin}_$par_emax.xml
  file_model_final=$dir_results/model_final_${par_emin}_$par_emax.xml
  file_result_1st=$dir_results/result_1st_${par_emin}_$par_emax.dat
  file_result_final=$dir_results/result_final_${par_emin}_$par_emax.dat

  gtbin evfile=$file_filtered_gti scfile=$file_spacecraft outfile=$file_ccube algorithm=CCUBE ebinalg=LOG emin=$par_emin emax=$par_emax enumbins=$par_enumbins nxpix=$par_nxpix nypix=$par_nypix binsz=$par_binsz coordsys=CEL xref=$par_ra yref=$par_dec axisrot=0 proj=AIT &&
  gtexpcube2 infile=$file_ltcube cmap=none outfile=$file_expcube irfs=$par_irfs nxpix=400 nypix=400 binsz=0.2 coordsys=CEL xref=$par_ra yref=$par_dec axisrot=0 proj=AIT ebinalg=LOG emin=$par_emin emax=$par_emax enumbins=$par_enumbins ebinfile=none &&
  gtsrcmaps scfile=$file_spacecraft expcube=$file_ltcube cmap=$file_ccube srcmdl=$file_model_initial bexpmap=$file_expcube outfile=$file_srcmap irfs=$par_irfs ptsrc=no &&
  gtlike irfs=$par_irfs expcube=$file_ltcube srcmdl=$file_model_initial statistic=BINNED optimizer=DRMNFB evfile=$file_filtered_gti scfile=$file_spacecraft cmap=$file_srcmap bexpmap=$file_expcube sfile=$file_model_1st results=$file_result_1st &&
  gtlike irfs=$par_irfs expcube=$file_ltcube srcmdl=$file_model_1st statistic=BINNED optimizer=NEWMINUIT evfile=$file_filtered_gti scfile=$file_spacecraft cmap=$file_srcmap bexpmap=$file_expcube sfile=$file_model_final results=$file_result_final &&

  flag=1 || flag=0

  [[ "x$flag" = "x0" ] && continue

  flux=`egrep "$par_srcname|Flux" $file_result_final | grep $par_srcname -A 1 | grep Flux | cut -d "'" -f 4 | sed 's/\+\/-//'`
  TS=`egrep "$par_srcname|TS" $file_result_final | grep $par_srcname -A 1 | grep TS | cut -d "'" -f 4`

  if [ `awk -v ts=$TS "BEGIN{if(ts > 4) print 1; else print 0}"` = 1 ]
  then
    echo "$par_emin_g $par_emax_g $flux $TS" >> flux_tmp
  else
    echo "#$par_emin_g $par_emax_g $flux $TS" >> flux_tmp &&
    python ul.py ul.dat $par_srcname $par_irfs $par_emin $par_emax $file_srcmap $file_ltcube $file_expcube $file_model_final &&
    ul=`cat ul.dat | sed 's/^\[\([^ ]*\).*$/\1/'` &&
    echo "$par_emin_g $par_emax_g $ul 0 -1e9" >> flux_tmp &&
    rm -rf ul.dat &&
    flag=1 || flag=0
  fi
done

column -t flux_tmp > flux.dat
rm -rf flux_tmp

python plt_gen.py $par_srcname
gnuplot sed.plt

#!/bin/bash

par_srcname=M87
par_irfs=P7REP_SOURCE_V15

file_filtered=../data_binned/${par_srcname}.fits
file_filtered_gti=${par_srcname}_gti.fits
file_spacecraft=~/data_Fermi/spacecraft.fits
file_cmap=${par_srcname}_cmap.fits
file_ccube=${par_srcname}_ccube.fits
file_ltcube=${par_srcname}_ltcube.fits
#file_expmap=${par_srcname}_expmap.fits
file_expcube=${par_srcname}_expcube.fits
file_srcmap=${par_srcname}_srcmap.fits
file_model_initial=model_input_binned.xml
file_model_1st=model_1st_binned.xml
file_model_final=model_output_binned.xml
file_modelpred=${par_srcname}_modelpred.fits
file_residual=${par_srcname}_residual.fits
file_model_tsmap_resi=model_tsmap_resi.xml
file_tsmap_resi=${par_srcname}_tsmap_resi.fits

position=`gtvcut $file_filtered EVENTS | sed -n '/CIRCLE/ s/.*(\(.*\))/\1/p'`
par_ra=`echo $position | cut -d , -f 1` 
par_dec=`echo $position | cut -d , -f 2`
par_emin=200
par_emax=200000

#!/bin/bash

par_srcname=M87
par_irfs=P7REP_SOURCE_V15

file_filtered=../data_unbinned/${par_srcname}.fits
file_filtered_gti=${par_srcname}_gti.fits
file_spacecraft=~/data_Fermi/spacecraft.fits
file_cmap=${par_srcname}_cmap.fits
file_ltcube=${par_srcname}_ltcube.fits
file_expmap=${par_srcname}_expmap.fits
file_model_initial=model_input_binned.xml
file_model_1st=model_1st_binned.xml
file_model_final=model_output_binned.xml
file_model_tsmap_resi=model_tsmap_resi.xml
file_tsmap_resi=${par_srcname}_tsmap_resi.fits

position=`gtvcut $file_filtered EVENTS | sed -n '/CIRCLE/ s/.*(\(.*\))/\1/p'`
par_ra=`echo $position | cut -d , -f 1`
par_dec=`echo $position | cut -d , -f 2`
energies=`gtvcut $file_filtered EVENTS | grep -A 2 ENERGY | grep VAL | cut -d ' ' -f 2`
par_emin=`echo $energies | cut -d : -f 1`
par_emax=`echo $energies | cut -d : -f 2`

par_srcrad=20
par_nlong=200
par_nlat=200
par_nenergies=30

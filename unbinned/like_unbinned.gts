#!/bin/bash

. var_common.gts &&

#gtdiffrsp evfile=$file_filtered_gti scfile=$file_spacecraft srcmdl=$file_model_intitial irfs=$par_irfs &&

gtlike irfs=$par_irfs expcube=$file_ltcube srcmdl=$file_model_initial statistic=UNBINNED optimizer=DRMNFB evfile=$file_filtered_gti scfile=$file_spacecraft expmap=$file_expmap sfile=$file_model_1st results=result_1st.dat specfile=counts_spectra_1st.fits plot=yes &&

gtlike irfs=$par_irfs expcube=$file_ltcube srcmdl=$file_model_1st statistic=UNBINNED optimizer=NEWMINUIT evfile=$file_filtered_gti scfile=$file_spacecraft expmap=$file_expmap sfile=$file_model_final results=result_final.dat specfile=counts_spectra_final.fits plot=yes &&

echo

#!/bin/bash

. var_common.gts &&

par_nxpix=140
par_nypix=140
par_binsz=0.1

gtbin evfile=$file_filtered_gti scfile=$file_spacecraft outfile=$file_cmap algorithm=CMAP nxpix=$par_nxpix nypix=$par_nypix binsz=$par_binsz coordsys=CEL xref=$par_ra yref=$par_dec axisrot=0 proj=AIT &&

gtmodel srcmaps=$file_srcmap srcmdl=$file_model_final outfile=$file_modelpred irfs=$par_irfs expcube=$file_ltcube bexpmap=$file_expcube &&

farith $file_cmap $file_modelpred $file_residual SUB &&

echo

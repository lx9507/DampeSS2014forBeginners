#!/bin/bash

. var_common.gts &&

gttsmap evfile=$file_filtered_gti scfile=$file_spacecraft expmap=$file_expmap expcube=$file_ltcube srcmdl=$file_model_tsmap_resi outfile=$file_tsmap_resi irfs=$par_irfs optimizer=NEWMINUIT ftol=1e-2 nxpix=70 nypix=70 binsz=0.2 coordsys=CEL xref=$par_ra yref=$par_dec proj=AIT statistic=UNBINNED &&

echo

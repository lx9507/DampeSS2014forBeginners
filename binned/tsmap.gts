#!/bin/bash

. var_common.gts &&

gttsmap statistic=BINNED scfile=$file_spacecraft evfile=$file_filtered_gti cmap=$file_ccube bexpmap=$file_expcube expcube=$file_ltcube srcmdl=$file_model_tsmap_resi irfs=$par_irfs optimizer=NEWMINUIT outfile=$file_tsmap_resi nxpix=140 nypix=140 binsz=0.1 coordsys=CEL xref=$par_ra yref=$par_dec proj=AIT &&

echo

#!/bin/bash

. var_common.gts &&

gtbin evfile=$file_filtered_gti scfile=$file_spacecraft outfile=$file_cmap algorithm=CMAP nxpix=200 nypix=200 binsz=0.1 coordsys=CEL xref=$par_ra yref=$par_dec axisrot=0 proj=AIT &&

echo

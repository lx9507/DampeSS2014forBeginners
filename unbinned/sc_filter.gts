#!/bin/bash

. var_common.gts &&

gtmktime scfile=$file_spacecraft filter="(DATA_QUAL==1)&&(LAT_CONFIG==1)&&ABS(ROCK_ANGLE)<52" roicut=yes evfile=$file_filtered outfile=$file_filtered_gti &&

gtltcube evfile=$file_filtered_gti scfile=$file_spacecraft outfile=$file_ltcube dcostheta=0.025 binsz=1 &&

#python gtltcube_mp.py 5 $file_spacecraft $file_filtered_gti $file_ltcube --zmax 100 &&

gtexpmap evfile=$file_filtered_gti scfile=$file_spacecraft expcube=$file_ltcube outfile=$file_expmap irfs=$par_irfs srcrad=20 nlong=200 nlat=200 nenergies=30 &&

#python gtexpmap_mp.py 200 200 5 5 $file_spacecraft $file_filtered_gti $file_ltcube $par_irfs 20 30 $file_expmap &&

echo

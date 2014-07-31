# Binned Likelihood Method

Fermi-LAT[官方教程](http://fermi.gsfc.nasa.gov/ssc/data/analysis/scitools/binned_likelihood_tutorial.html)

## 目录结构

M87

>data_binned

>>events

>>M87.fits

>binned

>>where to put all the [scripts](/binned/)


## 变量定义

最好考虑多脚本之间的重用特性。

[var_common.gts](/binned/var_common.gts):
```bash
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
```

## 与飞船有关的计算

gtmktime, gtltcube, gtexpcube2.

[sc_filter.gts](/binned/sc_filter.gts):
```bash
#!/bin/bash

. var_common.gts &&

gtmktime scfile=$file_spacecraft filter="(DATA_QUAL==1)&&(LAT_CONFIG==1)&&ABS(ROCK_ANGLE)<52" roicut=yes evfile=$file_filtered outfile=$file_filtered_gti &&

gtltcube evfile=$file_filtered_gti scfile=$file_spacecraft outfile=$file_ltcube dcostheta=0.025 binsz=1 &&

#python gtltcube_mp.py 10 $file_spacecraft $file_filtered_gti $file_ltcube --zmax 100 &&

gtexpcube2 infile=$file_ltcube cmap=none outfile=$file_expcube irfs=$par_irfs nxpix=400 nypix=400 binsz=0.2 coordsys=CEL xref=$par_ra yref=$par_dec axisrot=0 proj=AIT ebinalg=LOG emin=$par_emin emax=$par_emax enumbins=30 ebinfile=none &&

echo
```

## 一个简单直观的view

gtbin.

[cmap.gts](/binned/cmap.gts):
```bash
#!/bin/bash

. var_common.gts &&

gtbin evfile=$file_filtered_gti scfile=$file_spacecraft outfile=$file_cmap algorithm=CMAP nxpix=200 nypix=200 binsz=0.1 coordsys=CEL xref=$par_ra yref=$par_dec axisrot=0 proj=AIT &&

echo
```

counts map:
![counts map](/binned/M87_cmap.png)

## Binned likelihood

gtbin, gtsrcmaps, gtlike.

[like_binned.gts](/binned/like_binned.gts):
```bash
#!/bin/bash

. var_common.gts &&

gtbin evfile=$file_filtered_gti scfile=$file_spacecraft outfile=$file_ccube algorithm=CCUBE ebinalg=LOG emin=$par_emin emax=$par_emax enumbins=30 nxpix=140 nypix=140 binsz=0.1 coordsys=CEL xref=$par_ra yref=$par_dec axisrot=0 proj=AIT &&

gtsrcmaps scfile=$file_spacecraft expcube=$file_ltcube cmap=$file_ccube srcmdl=$file_model_initial bexpmap=$file_expcube outfile=$file_srcmap irfs=$par_irfs ptsrc=no &&

gtlike irfs=$par_irfs expcube=$file_ltcube srcmdl=$file_model_initial statistic=BINNED optimizer=DRMNFB evfile=$file_filtered_gti scfile=$file_spacecraft cmap=$file_srcmap bexpmap=$file_expcube sfile=$file_model_1st results=result_1st.dat specfile=counts_spectra_1st.fits plot=yes &&

gtlike irfs=$par_irfs expcube=$file_ltcube srcmdl=$file_model_1st statistic=BINNED optimizer=NEWMINUIT evfile=$file_filtered_gti scfile=$file_spacecraft cmap=$file_srcmap bexpmap=$file_expcube sfile=$file_model_final results=result_final.dat specfile=counts_spectra_final.fits plot=yes &&

echo
```

两次gtlike的plot:
![DRMNFB](/binned/M87_binned_DRMNFB.png)
![NEWMINUIT](/binned/M87_binned_NEWMINUIT.png)

## 计算residual map作为对结果的检查

gtbin, gtmodel, farith.

[residual.gts](/binned/residual.gts):
```bash
#!/bin/bash

. var_common.gts &&

par_nxpix=140
par_nypix=140
par_binsz=0.1

gtbin evfile=$file_filtered_gti scfile=$file_spacecraft outfile=$file_cmap algorithm=CMAP nxpix=$par_nxpix nypix=$par_nypix binsz=$par_binsz coordsys=CEL xref=$par_ra yref=$par_dec axisrot=0 proj=AIT &&

gtmodel srcmaps=$file_srcmap srcmdl=$file_model_final outfile=$file_modelpred irfs=$par_irfs expcube=$file_ltcube bexpmap=$file_expcube &&

farith $file_cmap $file_modelpred $file_residual SUB &&

echo
```

残差图：
![residual map](/binned/M87_residual.png)
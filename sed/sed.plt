set term post eps solid enhanced color "Helvetica" 24 dl 4
set out "M87_sed.eps"
set tics scale 2
set log xy
set xlabel 'E [GeV]'
set ylabel 'E^2dN/dE [GeV cm^{-2} s^{-1}]'
set xr [0.166666666667:239.9976]
set yr [1.26831719088e-10:9.32399889837e-09]
set format y '10^{%L}'
set key font ',18'

set arrow 1 from 141.587427154,4.66199944919e-09 to 141.587427154,1.5539998164e-09 lw 1 lc rgb 'red'

plot 'flux.dat' u (sqrt($1*$2)):($3/($2-$1)*$1*$2):1:2:(($3-$4)/($2-$1)*$1*$2):(($3+$4)/($2-$1)*$1*$2)  t 'M87' w xye pt 7 ps 0.8 lw 2 lc rgb 'red'

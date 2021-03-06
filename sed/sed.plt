set term post eps solid enhanced color "Helvetica" 24 dl 4
set out "M87_sed.eps"
set tics scale 2
set log xy
set xlabel 'E [GeV]'
set ylabel 'E^2dN/dE [GeV cm^{-2} s^{-1}]'
set xr [0.1588656999:251.78248058]
set yr [1.89676724294e-10:8.30202201184e-09]
set format y '10^{%L}'
set key font ',18'

set arrow 1 from 141.587427154,4.64190462397e-09 to 141.587427154,1.54730154132e-09 lw 1 lc rgb 'red'

plot 'flux.dat' u (sqrt($1*$2)):($3/($2-$1)*$1*$2):1:2:(($3-$4)/($2-$1)*$1*$2):(($3+$4)/($2-$1)*$1*$2)  t 'M87' w xye pt 7 ps 0.8 lw 2 lc rgb 'red'

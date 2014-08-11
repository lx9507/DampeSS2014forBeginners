set term post eps solid enhanced color "Helvetica" 24 dl 4
set out "M87_lc.eps"
set tics scale 2
set xlabel 'Time(MET) [s]'
set ylabel 'counts [cm^{-2} s^{-1}]'
set xr [233427518.767:429584262.233]
set yr [-2.734055e-09:3.308829e-08]
set xtics 6e7
set ytics 1e-8
#set mytics 10
#set log y
#set format y '10^{%L}'
set key font ',18'


plot 'flux.dat' u (($1 + $2) / 2) : 3 : 1 : 2 : ($3 - $4) : ($3 + $4)  t 'M87' w xye pt 7 ps 0.8 lw 2 lc rgb 'red'

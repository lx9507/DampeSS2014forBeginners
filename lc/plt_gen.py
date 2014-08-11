import sys
import numpy as np

srcname = sys.argv[1]
tmin, tmax, flux, fluxErr, TS = np.loadtxt('flux.dat', dtype=float,
                                           unpack=True)

x = (tmin * tmax) / 2.0
y = flux
yerr = fluxErr

xmin = tmin.min()
xmax = tmax.max()

ymin = (y - yerr)[np.where(y > yerr)].min()
ymax = (y + yerr)[np.where(y > yerr)].max()

fin = open('lc.plt.in')
f = fin.readlines()
fin.close()


def ins():
    global inspnt
    tmp = inspnt
    inspnt = tmp + 1
    return tmp

inspnt = f.index('#set arrow\n')
f.remove(f[inspnt])

arrow_end = 3.0
arrow_number = 1
if not isinstance(x, np.ndarray):
    '''Only one line in flux.dat'''
    (x, y, yerr, TS) = ([x], [y], [yerr], [TS])
for xv, yv, ye, ts in zip(x, y, yerr, TS):
    if abs(ye) < 1e-6 and abs(ts + 1e9) < 1:
        f.insert(ins(), 'set arrow ' + str(arrow_number) + ' from '
                 + str(xv) + ',' + str(yv) + ' to '
                 + str(xv) + ',' + str(yv / arrow_end)
                 + " lw 1 lc rgb 'red'\n")
        arrow_number += 1
        ymin = min(yv / arrow_end, ymin)

xr = xmax - xmin
yr = ymax - ymin
xmin -= xr / 30
xmax += xr / 30
ymin -= yr / 10
ymax += yr / 5

for i in xrange(len(f)):
    f[i] = f[i].replace('srcname', srcname)
    f[i] = f[i].replace('set xr', 'set xr [' + str(xmin) + ':'
                        + str(xmax) + ']')
    f[i] = f[i].replace('set yr', 'set yr [' + str(ymin) + ':'
                        + str(ymax) + ']')

fout = open('lc.plt', mode='w')
fout.writelines(f)
fout.close()

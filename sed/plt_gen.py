import sys
import numpy as np

srcname = sys.argv[1]
emin, emax, flux, fluxErr, TS = np.loadtxt(
    'flux.dat', dtype=float, unpack=True)

x = np.sqrt(emin * emax)
y = flux * emin * emax / (emax - emin)
yerr = fluxErr * emin * emax / (emax - emin)

xmin = emin.min()
xmax = emax.max()

ymin = (y - yerr)[np.where(y > yerr)].min()
ymax = (y + yerr)[np.where(y > yerr)].max()

fin = open('sed.plt.in')
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
    if abs(ye) < 1e-30 and abs(ts + 1e9) < 1e-20:
        f.insert(ins(), 'set arrow ' + str(arrow_number) + ' from '
                 + str(xv) + ',' + str(yv) + ' to '
                 + str(xv) + ',' + str(yv / arrow_end)
                 + " lw 1 lc rgb 'red'\n")
        arrow_number += 1
        ymin = min(yv / arrow_end, ymin)

xr = xmax / xmin
yr = ymax / ymin
xmin /= xr ** (1.0 / 30)
xmax *= xr ** (1.0 / 30)
ymin /= yr ** (1.0 / 10)
ymax *= yr ** (1.0 / 5)

for i in xrange(len(f)):
    f[i] = f[i].replace('srcname', srcname)
    f[i] = f[i].replace('set xr', 'set xr [' + str(xmin) + ':'
                        + str(xmax) + ']')
    f[i] = f[i].replace('set yr', 'set yr [' + str(ymin) + ':'
                        + str(ymax) + ']')

fout = open('sed.plt', mode='w')
fout.writelines(f)
fout.close()

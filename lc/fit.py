import numpy as np

flux, fluxErr = np.loadtxt('flux.dat', usecols=(2, 3), unpack=True)

'''Avoiding the upper limit points'''
x = flux[np.where(abs(fluxErr) > 1e-30)]
xerr = fluxErr[np.where(abs(fluxErr) > 1e-30)]
w = 1.0 / xerr ** 2

dof = len(x) - 1

a = (w * x).sum() / w.sum()
aerr = np.sqrt(1.0 / w.sum())
chi2 = ((x - a) ** 2 * w).sum()

print 'y =', a
print 'chi2 / dof =', chi2, '/', dof, '=', chi2 / dof

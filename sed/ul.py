import sys
from BinnedAnalysis import *
from UpperLimits import UpperLimits

filename, par_srcname, par_irfs = sys.argv[1: 4]
par_emin = float(sys.argv[4])
par_emax = float(sys.argv[5])
file_srcMaps, file_expCube, file_binnedExpMap, file_srcModel = sys.argv[6: 10]


obs = BinnedObs(srcMaps=file_srcMaps, expCube=file_expCube,
                binnedExpMap=file_binnedExpMap, irfs=par_irfs)
like = BinnedAnalysis(obs, srcModel=file_srcModel, optimizer='NEWMINUIT')

like.fit(verbosity=0, covar=True)
like.Ts(par_srcname)

ul = UpperLimits(like)

ul[par_srcname].compute(emin=par_emin, emax=par_emax)
f = open(filename, 'w')
print >> f, ul[par_srcname].results
f.close()

import sys
from UnbinnedAnalysis import *
from UpperLimits import UpperLimits

filename, par_srcname, par_irfs = sys.argv[1: 4]
par_emin = float(sys.argv[4])
par_emax = float(sys.argv[5])
file_eventFile, file_scFile, file_expMap, file_expCube, file_srcModel = sys.argv[6: 11]


obs = UnbinnedObs(eventFile=file_eventFile, scFile=file_scFile,
                  expMap=file_expMap, expCube=file_expCube, irfs=par_irfs)
like = UnbinnedAnalysis(obs, srcModel=file_srcModel, optimizer='NewMinuit')

like.fit(verbosity=0, covar=True)
like.Ts(par_srcname)

ul = UpperLimits(like)

ul[par_srcname].compute(emin=par_emin, emax=par_emax)
f = open(filename, 'w')
print >> f, ul[par_srcname].results
f.close()

from astropy.io import fits
from math import floor
import numpy as np
import sys
from math import modf
arg1 = sys.argv[1]
arg2 = sys.argv[2]
pha_list = fits.open(arg1)
pha_data = pha_list[1].data
Time = pha_data['TIME']
RA = pha_data['Roll_RA']
DEC = pha_data['Roll_DEC']
ROT = pha_data['ROLL_ROT']
#Trigged_time=int(arg2)
t=modf(float(arg2))
#print t[1]
RA1=RA[(Time == t[1])]
DEC1=DEC[(Time == t[1])]
ROT1=ROT[(Time == t[1])]
#Time1=Time[(Time == t[1])]
print RA1
print DEC1
print ROT1
#print Time1


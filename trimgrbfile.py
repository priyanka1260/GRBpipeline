#!/usr/bin/env python2.7

"""
    trim_data.py infile outfile noisyfile

    Aim: Trim a data file to tmin and tmax limits

    Version  : $Rev: 495 $
    Last Update: $Date: 2015-10-09 11:40:52 +0530 (Fri, 09 Oct 2015) $

"""

# Version descriptions:
# v1.1	: Also trims veto spectrum extension

from astropy.io import fits
from astropy.table import Table
from astropy.stats import sigma_clip
import numpy as np
import sys

import argparse
parser = argparse.ArgumentParser(epilog="""
    *** NOTE ***
    Header keywords like tstart, tstop etc are NOT properly updated!
    The GTI extension also remains unchanged!

    Version  : $Rev: 495 $
    Last Update: $Date: 2015-10-09 11:40:52 +0530 (Fri, 09 Oct 2015) $

""")
parser.add_argument("infile", help="Event file to be used for processing", type=str)
parser.add_argument("outfile", type=str, help="Output file with noisy pixels suppressed")
parser.add_argument("--tmin", help="Start time (in spacecraft seconds). Default = start of file", type=float, default=0) # set LOW default
parser.add_argument("--tmax", help="End time (in spacecraft seconds). Default = end of file", type=float, default=1e15) # set HIGH default
parser.add_argument("-v", "--verbose", help="Give verbose on-screen output", type=bool, default=True)
parser.add_argument("--noe", help= "Give the number of extension(noe) to be trimmed, for attfile & orbfile noe will be 1 ", default=5, type=int)
args = parser.parse_args()
#print args
#print args.echo
noe=args.noe
#print noe



#------------------------------------------------------------------------
# Open the input event file
hdu = fits.open(args.infile)
# HDU[0] is dummy, 1-4 are quadrants

# Create output file. Exit if it already exists
fits.writeto(args.outfile, hdu[0].data, hdu[0].header)
if args.verbose: 
	print ("Wrote HDU 0")


for quad in np.arange(noe):
    # Note that the output file needs quadrants from 0-3, but HDU extensions are 1-4
    # Also process extension 5, which has veto spectrum
    if args.verbose: print ("Processing quadrant {quad}/4 ".format(quad=quad+1)),
    data = hdu[quad+1].data
    if hdu[quad+1].header['naxis2'] > 0:
        timestamps = data['Time']
        tmin = max([np.floor(min(timestamps)), args.tmin])
        tmax = min([np.floor(max(timestamps)), args.tmax])
        if args.verbose: print (tmin, tmax, args.tmin, args.tmax)
        if args.verbose: sys.stdout.flush()
        select = np.where( (hdu[quad+1].data['Time'] >= tmin) & (hdu[quad+1].data['Time'] <= tmax) )
        data = hdu[quad+1].data[select]
    fits.append(args.outfile, data, header=hdu[quad+1].header)#, verify=False)

#for ext in range(6, len(hdu)):
    #fits.append(args.outfile, hdu[ext].data, hdu[ext].header)




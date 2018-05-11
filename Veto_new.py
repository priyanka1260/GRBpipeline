#!/usr/bin/env python
#Vedant Kumar, jun 23, 2016
#Last Update Priyanka & Vidushi ,feb 2018 

"""
    gen_vetolightcurve.py infile
    
	Genrate the veto count plot for Gamma Ray Burst in CZTI data using mkf file 

    Type gen_vetolightcurve.py -h to get help
    Version:
    Last Update: $Date: 2016-04-20 16:05:56 +0530 (Wed, 20 Apr 2016) $

"""

from astropy.io import fits
import os,subprocess,argparse 
import numpy as np
import matplotlib.pyplot as plt
from astropy.table import Table
import math
from matplotlib.backends.backend_pdf import PdfPages
parser=argparse.ArgumentParser(description= 'Genrate the veto light curve for transient event in all four quadrant')
parser.add_argument("infile",help='enter the corresponding file to genrate the veto light curve', type=str)
parser.add_argument("outfile", nargs="?", default="products/czti_lc", type=str, help="Stem to be prepended to all output files")
parser.add_argument("--tmin" , help="start time for veto light curve (e.g. triger time-100 seconds). Default=start of file", type=float)
parser.add_argument("--tmax" , help="end time for veto light curve (e.g. triger time +100 seconds). Default=end of file", type=float)
parser.add_argument("--tmark", help="Time to mark with vertical lines (seconds). Default = None", type=float)
#parser.add_argument("GRBNAME", help ="enter the GRBNAME", type=str)
#parser.add_argument("GRBLOCATION", help ="enter the GRB LOCATION to save", type=str)

parser.add_argument("--tbin" , help= "Time binning for veto light curve. Default = 20", type=float, default=20)
parser.add_argument("-p", "--plottype", help="Type of output file to produce (png, pdf)", type=str, default='pdf')
args=parser.parse_args()



if args.infile:
	veto_file=fits.open(args.infile)
	hdu_data=veto_file[1].data
	Veto_Q1=hdu_data['Q1_VetoCounter']
	Veto_Q2=hdu_data['Q2_VetoCounter']
	Veto_Q3=hdu_data['Q3_VetoCounter']
	Veto_Q4=hdu_data['Q4_VetoCounter']
	ut_time =hdu_data['Time']


if args.tmin:
	tmin =args.tmin
if args.tmax:
	tmax =args.tmax

if args.plottype == 'pdf':
    plotfile = PdfPages("{stem}_lightcurves.pdf".format(stem=args.outfile))



def find_nearest(array,value):
    idx = (np.abs(array-value)).argmin()
    return array[idx]


if args.tmin:
	TMIN=find_nearest(ut_time,tmin)
	

if args.tmax:
	TMAX=find_nearest(ut_time,tmax)



Q1_trim_veto=Veto_Q1[np.where(ut_time==TMIN)[0][0]: np.where(ut_time==TMAX)[0][0]]
Q2_trim_veto=Veto_Q2[np.where(ut_time==TMIN)[0][0]: np.where(ut_time==TMAX)[0][0]]
Q3_trim_veto=Veto_Q3[np.where(ut_time==TMIN)[0][0]: np.where(ut_time==TMAX)[0][0]]
Q4_trim_veto=Veto_Q4[np.where(ut_time==TMIN)[0][0]: np.where(ut_time==TMAX)[0][0]]
ut_trim_time= ut_time[np.where(ut_time==TMIN)[0][0]: np.where(ut_time==TMAX)[0][0]]



fig = plt.figure()
fig.suptitle('Veto Light Curve', fontsize=14, fontweight='bold')
ax = fig.add_subplot(221)
ax.set_title('Quad A')
ax.set_xlabel('Time (sec)', fontsize=12)
ax.set_ylabel('Counts/sec', fontsize=12)
ax.yaxis.label.set_color('red')
ax.xaxis.label.set_color('red')
plt.subplots_adjust(hspace=0.5,wspace=0.5)

if args.tmark > 0: plt.axvline([args.tmark], color='red', linestyle='dashed', label='Marked times')
plt.plot(ut_trim_time,Q1_trim_veto)

ax = fig.add_subplot(222)
ax.set_title('Quad B')
ax.set_xlabel('Time (sec)', fontsize=12)
ax.set_ylabel('Counts/sec', fontsize=12)
ax.yaxis.label.set_color('red')
ax.xaxis.label.set_color('red')
plt.subplots_adjust(hspace=0.5,wspace=0.5)

if args.tmark > 0: plt.axvline([args.tmark], color='red', linestyle='dashed', label='Marked times')
plt.plot(ut_trim_time,Q2_trim_veto)

ax = fig.add_subplot(223)
ax.set_title('Quad C')
ax.set_xlabel('Time (sec)', fontsize=12)
ax.set_ylabel('Counts/sec', fontsize=12)
ax.yaxis.label.set_color('red')
ax.xaxis.label.set_color('red')
plt.subplots_adjust(hspace=0.5,wspace=0.5)

if args.tmark > 0: plt.axvline([args.tmark], color='red', linestyle='dashed', label='Marked times')
plt.plot(ut_trim_time,Q3_trim_veto)
   
ax = fig.add_subplot(224)
ax.set_title('Quad D')
ax.set_xlabel('Time (sec)', fontsize=12)
ax.set_ylabel('Counts/sec', fontsize=12)
ax.yaxis.label.set_color('red')
ax.xaxis.label.set_color('red')
plt.subplots_adjust(hspace=0.5,wspace=0.5)
if args.tmark > 0: plt.axvline([args.tmark], color='red', linestyle='dashed', label='Marked times')
plt.plot(ut_trim_time,Q4_trim_veto)
plt.tight_layout()



"""
plt.figure(1)
plt.subplot(221)
plt.subtitle('Veto Light Curve')
plt.xlabel('Universal_Timne (sec)')
plt.ylabel('veto_count')
plt.title('Quad A')
if args.tmark > 0: plt.axvline([args.tmark], color='black', linestyle='dashed', label='Marked times')
plt.plot(ut_trim_time,Q1_trim_veto)


plt.subplot(222)
plt.xlabel('Universal_Timne (sec)')
plt.ylabel('veto_count')
plt.title('Quad B')
if args.tmark > 0: plt.axvline([args.tmark], color='black', linestyle='dashed', label='Marked times')
plt.plot(ut_trim_time,Q2_trim_veto)


plt.subplot(223)
plt.xlabel('Universal_Timne (sec)')
plt.ylabel('veto_count')
plt.title('Quad C')
if args.tmark > 0: plt.axvline([args.tmark], color='black', linestyle='dashed', label='Marked times')
plt.plot(ut_trim_time,Q3_trim_veto)


plt.subplot(224)
plt.xlabel('Universal_Timne (sec)')
plt.ylabel('veto_count')
plt.title('Quad D')
if args.tmark > 0: plt.axvline([args.tmark], color='black', linestyle='dashed', label='Marked times')
plt.plot(ut_trim_time,Q4_trim_veto)

"""


if args.plottype == 'pdf':

	plotfile.savefig()
else:
	plt.show()	
	plt.savefig(args.outfile + "_veto." + args.plottype)
	#GRBNAME=args.GRBNAME
	#print(GRBNAME)
	#GRBNAME=str('AS1CZT_')+GRBNAME+str('_VetoLightCurve.png')
	#print(GRBNAME)
	#GRBLOCATION=args.GRBLOCATION
	#print(GRBLOCATION)
	#GRBNAME=str(GRBLOCATION)+str(GRBNAME)
	#print(GRBNAME)
	#plt.savefig(GRBNAME)
plt.show()	
if args.plottype == 'pdf':
    plotfile.close()



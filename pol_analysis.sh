#!/bin/bash
bc_evt=$1
bunch_clean_livetime=$2
GRBname_path=$3

quad_bc_ds_evt=`echo $bc_evt|sed 's/bc.evt/quad_bc_ds.evt/'`
quad_bc_ds_evt=$GRBname_path/$(basename $quad_bc_ds_evt)
echo $quad_bc_ds_evt

#Step-1: Running CZTDATASEL
cztdatasel infile=$bc_evt gtifile=$bc_evt gtitype="QUAD" outfile=$quad_bc_ds_evt clobber="y" history="y"
echo "cztdatasel infile=$bcevt gtifile=$bcevt gtitype="QUAD" outfile=$quad_bc_ds_evt clobber="y" history="y"" 

quad_pc_evt=`echo $quad_bc_ds_evt |sed 's/quad_bc_ds.evt/quad_bc_ds_pc.evt/'`
quad_pc_evt=$GRBname_path/$(basename $quad_pc_evt)
echo $quad_pc_evt

quad_pc_double_evt=`echo $quad_bc_ds_evt|sed 's/quad_bc_ds.evt/quad_bc_ds_pc.dblevt/'`
quad_pc_double_evt=$GRBname_path/$(basename $quad_pc_double_evt)
echo $quad_pc_double_evt

quad_livetime=`echo $quad_bc_ds_evt|sed 's/quad_bc_ds.evt/quad_livetime.fits/'`
quad_livetime=$GRBname_path/$(basename $quad_livetime)
echo $quad_livetime

quad_badpix=`echo $quad_bc_ds_evt|sed 's/quad_bc_ds.evt/quad_badpix.fits/'`
quad_badpix=$GRBname_path/$(basename $quad_badpix)
echo $quad_badpix

#step-2:CZTPIXCLEAN

echo "Enter par_det_count_thresh and par_pix_count_thresh::"
read det_th
read pix_th
echo "Enter par_det_tbinsize and par_pix_tbinsize:"
read det_tbinsize
read pix_tbinsize

	
echo "cztpixclean par_infile=$quad_bc_ds_evt par_inlivetimefile=$bunch_clean_livetime  par_outfile1=$quad_pc_evt par_outlivetimefile=$quad_livetime  par_badpixfile=$quad_badpix1 par_outfile2=$quad_pc_double_evt par_writedblevt="y" par_nsigma=5 par_det_tbinsize=$Tbin par_pix_tbinsize=$Tbin par_det_count_thresh=$det_th par_pix_count_thresh=$pix_th" #>>$grblogs


cztpixclean par_writedblevt="y" par_outfile2=$quad_pc_double_evt par_infile=$quad_bc_ds_evt par_inlivetimefile=$bunch_clean_livetime par_outfile1=$quad_pc_evt par_outlivetimefile=$quad_livetime  par_badpixfile=$quad_badpix par_nsigma=5 par_det_tbinsize=$det_tbinsize par_pix_tbinsize=$pix_tbinsize par_det_count_thresh=$det_th par_pix_count_thresh=$pix_th

#step-3:CZTEVTCLEAN

quad_clean_evt=`echo $quad_bc_ds_evt|sed 's/quad_bc_ds.evt/quad_clean_'"$det_th"'_'"$pix_th"'.evt/'`
echo "cztevtclean infile=$quad_pc_evt outfile=$quad_clean_evt alphaval="0" vetorange="0" clobber="y" isdoubleEvent="n" history="y"" #>>$grblogs 
quad_clean_evt=$GRBname_path/$(basename $quad_clean_evt)
	   
cztevtclean infile=$quad_pc_evt outfile=$quad_clean_evt alphaval="0" vetorange="0" clobber="y" isdoubleEvent="n" history="y"
	
quad_clean_dblevt=`echo $quad_bc_ds_evt|sed 's/quad_bc_ds.evt/quad_clean_'"$det_th"'_'"$pix_th"'.dblevt/'`
echo " cztevtclean infile=$quad_pc_double_evt outfile=$quad_clean_dblevt alphaval="0" vetorange="0" clobber="y" isdoubleEvent="y" history="y"" #>>$grblogs  
quad_clean_dblevt=$GRBname_path/$(basename $quad_clean_dblevt)
cztevtclean infile=$quad_pc_double_evt outfile=$quad_clean_dblevt alphaval="0" vetorange="0-0" clobber="y" isdoubleEvent="y" history="y"








        


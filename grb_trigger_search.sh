#!/bin/bash

#GRB_triggered_search.sh
#Vedant Kumar, jun 23, 2016
#Last Update:Priyanka Shahane,Dec 2017
#Version 1.0------------------------------------------
###  The purpose of this script is automate the grb analysis for a particular GRB. 
###  It genrate the directory structure, products like CZT Light Curve, Veto Light Curve, GRB DPH. 
###  And Calculate thetax, thetay.
#Updates
#Finding orbit by given UT time using script Finding_orbit.sh 
#Theta calculation is done Automatically using script Theta_values_calculation.py and result is printed on terminal 

########################################################################################################################
## e.g. grb_trigger_search.sh GRB180204A 2018-02-04 02:36:16 330.118 +30.846
########################################################################################################################
echo "#####################  Parsing the argument for processing Gamma Ray Burst and Finding the orbit containing Gamma Ray Burst ######################################"
echo -e ' \t' 
GRBNAME=$1
DATE=$2
TIME=$3
RA=$4
DEC=$5
grblogs=/data2/czti/special/grblogs/$GRBNAME".log"

echo "########################################## Finding orbit #################################################" 
orbit_num=`Finding_orbit.sh $DATE $TIME` 
#echo $orbit_num
echo "orbit_num=`Finding_orbit.sh $DATE $TIME`">>$grblogs

echo $orbit_num


Status=$(echo `echo $orbit_num|cut -d ' ' -f1`)
echo "Status of data in orbit: $Status"

Status_str=`echo "DataGap"`


if [[ "$Status" != "$Status_str" ]]
then


	echo "###################################  Converting UTC to AstroSat time ##############################################"
	Time=`echo $DATE $TIME`
	Output=$( Astrosat_Time.py -iso "$Time")
	Astrosat_seconds=`echo $Output|cut -d ',' -f2`

	echo -e ' \t ' 
	echo "######################################  Start Processing $GRBNAME  #######################################"
	echo "######################################  Start Processing $GRBNAME  #######################################" >>$grblogs
	echo "#####Processing Time:: $(date "+%Y-%m-%d %H:%M:%S")" >>$grblogs

	echo -e ' \t' 
	echo "$GRBNAME corresponds to orbit:$orbit_num"
	echo "$GRBNAME corresponds to orbit:$orbit_num" >>$grblogs
	echo -e ' \t'

	echo "Input Provided:: 
	 GRBNAME:          $GRBNAME 
	 Orbit Number:     $orbit_num 
	 Astrosat_seconds: $Astrosat_seconds 
	 RA:               $RA 
	 DEC:              $DEC" >>$grblogs


	echo "Input Provided:: 
	 GRBNAME:          $GRBNAME 
 	Orbit Number:     $orbit_num 
 	Astrosat_seconds: $Astrosat_seconds 
 	RA:               $RA 
 	DEC:              $DEC"


	tmark=$Astrosat_seconds
	tmin=`echo "$Astrosat_seconds-500"|bc -l`
	tmax=`echo "$Astrosat_seconds+500"|bc -l`



	echo "#########  Defining Defalut path ######"
	specail=/data2/czti/special
	pyflight=/home/cztipoc/czti_svn/trunk/code/pyflight
	caldbbadpix=/home/cztipoc/CALDB/data/as1/czti/bcf
	modeM0l2=$orbit_num/modeM0
	auxl2=$orbit_num/aux/aux1


	echo -e ' \t'
	echo "#####################################  Creating directory Structure for $GRBNAME #########################"
	echo "#####Creating directory Structure for $GRBNAME:: " >>$grblogs
	echo -e ' \t'
	echo "`echo -e ' \t'`" >>$grblogs
     

     	 mkdir $specail/$GRBNAME
     	 echo "mkdir $specail/$GRBNAME" >>$grblogs
    	 mkdir $specail/$GRBNAME/modeM0_up
    	 echo "mkdir $specail/$GRBNAME/modeM0_up" >>$grblogs
	 mkdir $specail/$GRBNAME/aux
	 echo "mkdir $specail/$GRBNAME/aux" >>$grblogs
	 mkdir $specail/$GRBNAME/products
     	 echo "mkdir $specail/$GRBNAME/products" >>$grblogs


	echo "#####################################  Creating the required soft links ####################################"
	echo "######Creating the required soft links::" >>$grblogs
	echo -e ' \t'
	echo "`echo -e ' \t'`" >>$grblogs
	
 	 ln -s $pyflight/relqe.txt $specail/$GRBNAME
 	 ln -s $pyflight/thresholds.txt $specail/$GRBNAME
 	 ln -s $orbit_num/modeM0 $specail/$GRBNAME

 	 echo "ln -s $pyflight/relqe.txt $specail/$GRBNAME" >>$grblogs
 	 echo "ln -s $pyflight/thresholds.txt $specail/$GRBNAME" >>$grblogs
 	 echo "ln -s $orbit_num/modeM0 $specail/$GRBNAME"  >>$grblogs

  
	echo "##################################  Defining new path and variable name ########################################################"
	echo "#####Defining new path and variable name::"  >>$grblogs
	echo "`echo -e ' \t'`"  >>$grblogs


   	products=$specail/$GRBNAME/products
   	modeM0=$specail/$GRBNAME/modeM0
   	aux=$specail/$GRBNAME/aux
   	modeM0_up=$specail/$GRBNAME/modeM0_up
   	echo "products=$specail/$GRBNAME/products" >>$grblogs
   	echo "modeM0=$specail/$GRBNAME/modeM0" >>$grblogs
   	echo "aux=$specail/$GRBNAME/aux" >>$grblogs
   	echo "modeM0_up=$specail/$GRBNAME/modeM0_up" >>$grblogs



	echo "#############################################  Finding Products for $GRBNAME   #################################################"
  	 evtfile=$(find $modeM0/ -name "*quad_clean.evt")
   	echo "Quad Clean event file: $evtfile"
   	attfile=$(find $auxl2 -name "*.att")
   	echo "Atitude file: $attfile"
   	orbfile=$(find $auxl2 -name "*.orb")
  	 echo "Orbit File: $orbfile"
  	 mkffile=$(find $orbit_num/ -name "*level2.mkf")
  	 echo "MKF File: $mkffile"
  	 bcevt=$(find $modeM0/ -name "*level2_bc.evt")
  	 echo $bcevt
   	gtifile=$(find $modeM0/ -name "*.gti")
  	 echo $gtifile

   
	echo "#############################################  Finding Products for $GRBNAME   #################################################"
	echo "#####Copying crucial Products for $GRBNAME::" >>$grblogs
	echo "`echo -e ' \t'`" >>$grblogs

  	cp $bcevt $modeM0_up/
   	cp $gtifile $modeM0_up/
   	cp $attfile $aux/
   	cp $orbfile $aux/
   	cp $mkffile $specail/$GRBNAME/

      
  	echo "cp $bcevt $modeM0_up/" >>$grblogs
   	echo "cp $gtifile $modeM0_up/" >>$grblogs
   	echo "cp $attfile $aux/" >>$grblogs
   	echo "cp $orbfile $aux/" >>$grblogs
  	echo "cp $mkffile $specail/$GRBNAME/" >>$grblogs



 	common_bc_ds_evt=`echo $bcevt|sed 's/bc.evt/quad_bc_ds.evt/'`
 	common_bc_ds_evt=$modeM0_up/$(basename $common_bc_ds_evt)

 	echo $common_bc_ds_evt

	echo "####################################  Genrating Datasel file file for processing ###########################"
	echo "#####Genrating Datasel file for processing::" >>$grblogs
	echo "`echo -e ' \t'`" >>$grblogs


         cztdatasel infile=$bcevt gtifile=$bcevt gtitype="COMMON" outfile=$common_bc_ds_evt clobber="y" history="y"
         echo 'cztdatasel infile=$bcevt gtifile=$bcevt gtitype="COMMON" outfile=$common_bc_ds_evt clobber="y" history="y"' >>$grblogs
 
 
	 echo $common_bc_ds_evt
	 bunch_clean_livetime=$(find $modeM0/ -name "*bc_livetime.fits")
	 echo $bunch_clean_livetime


	 common_pc_evt=`echo $common_bc_ds_evt|sed 's/quad_bc_ds.evt/quad_bc_ds_pc.evt/'`
	 common_pc_evt=$modeM0_up/$(basename $common_pc_evt)
	 echo $common_pc_evt


	 dbl_evt=`echo $common_bc_ds_evt|sed 's/quad_bc_ds.evt/quad.dblevt/'`
 	dbl_evt=$modeM0_up/$(basename $dbl_evt)
 	echo $dbl_evt


	 common_livetime=`echo $common_bc_ds_evt|sed 's/quad_bc_ds.evt/quad_livetime.fits/'`
 	common_livetime=$modeM0_up/$(basename $common_livetime)
	 echo $common_livetime



	 common_badpix=`echo $common_bc_ds_evt|sed 's/quad_bc_ds.evt/quad_badpix.fits/'`
	 common_badpix=$modeM0_up/$(basename $common_badpix)
	 echo $common_badpix

	 common_clean_evt=`echo $common_bc_ds_evt|sed 's/quad_bc_ds.evt/quad_clean.evt/'`
	 common_clean_evt=$modeM0_up/$(basename $common_clean_evt)
	 echo common_clean_evt



	echo -e ' \t'
	echo "####################################  Genrating pixclean evt file for processing ###########################"
	echo "#####Genrating pixclean evt file for processing::" >>$grblogs
	echo -e ' \t'
	echo "`echo -e ' \t'`" >>$grblogs


            echo "cztpixclean par_infile=$common_bc_ds_evt par_inlivetimefile=$bunch_clean_livetime par_writedblevt=n par_outfile1=$common_pc_evt par_outfile2=$dbl_evt par_outlivetimefile=$common_livetime  par_badpixfile=$common_badpix par_nsigma=5 par_det_tbinsize=1 par_pix_tbinsize=1 par_det_count_thresh=1000 par_pix_count_thresh=100">>$grblogs


            cztpixclean par_infile=$common_bc_ds_evt par_inlivetimefile=$bunch_clean_livetime par_writedblevt=n par_outfile1=$common_pc_evt par_outfile2=$dbl_evt par_outlivetimefile=$common_livetime  par_badpixfile=$common_badpix par_nsigma=5 par_det_tbinsize=1 par_pix_tbinsize=1 par_det_count_thresh=2000 par_pix_count_thresh=200




	echo "###################################   Genrating common clean evt file #######################################"
	echo "#####Genrating common clean evt file::" >>$grblogs
	echo "`echo -e ' \t'`">>$grblogs

           
           echo "cztevtclean infile=$common_pc_evt outfile=$common_clean_evt alphaval="0" vetorange="0" clobber=y isdoubleEvent=n history=y" >>$grblogs           
           cztevtclean infile=$common_pc_evt outfile=$common_clean_evt alphaval="0" vetorange="0" clobber=y isdoubleEvent=n history=y


	
	echo "###################################   Deleting Uncessary outputs #######################################"
	echo "#####Deleting Uncessary outputs" >>$grblogs
	echo "`echo -e ' \t'`" >>$grblogs

           delete=$(find $modeM0_up/ -name *quad.dblevt  -o -name *bc_ds_pc.evt -o -name *quad_livetime.fits -o -name *quad_bc_ds.evt -o -name *quad_badpix.fits -o -name *bc.evt -o -name *.gti)
           echo "The following file is being deleted: $delete"
           echo "The following file is being deleted: $delete" >>$grblogs
          # rm -rf $delete


	evtfile_up=$(find $modeM0_up/ -name "*quad_clean.evt")
	attfile_up=$(find $aux/ -name "*.att")
	orbfile_up=$(find $aux/ -name "*.orb")

	evtfile_up_1200sec=$modeM0_up/"AS1CZT_"$GRBNAME"_quad_clean.evt"
	attfile_up_1200sec=$aux/"AS1CZT_"$GRBNAME".att"
	orbfile_up_1200sec=$aux/"AS1CZT_"$GRBNAME".orb"

	echo $evtfile_up_1000sec
	echo $attfile_up_1000sec
	echo $orbfile_up_1000sec


	echo $orbfile_up
	echo $evtfile
 



	echo -e ' \t'
	echo "#####################################  Creating config file  ###############################################"
	echo "Creating config file::" >>$grblogs
	echo -e ' \t'
	echo "`echo -e ' \t'`" >>$grblogs


	echo "update_conf.py $GRBNAME $orbit_num  $specail/$GRBNAME/  $products/ $modeM0_up/ --tmark $tmark --tmin $tmin --tmax $tmax --RA $RA --DEC $DEC"
	echo -e ' \t'
	echo "update_conf.py $GRBNAME $orbit_num  $specail/$GRBNAME/  $products/ $modeM0_up/ --tmark $tmark --tmin $tmin --tmax $tmax --RA $RA --DEC $DEC" >>$grblogs

	update_conf.py $GRBNAME $orbit_num  $specail/$GRBNAME/  $products/ $modeM0_up/ --tmark $tmark --tmin $tmin --tmax $tmax --RA $RA --DEC $DEC



	confile=$(find $specail/$GRBNAME -name "*.conf")
           echo "Configuration File: $confile"
           echo "Configuration File: $confile" >>$grblogs



	echo "########################  confile=$(find $specail/$GRBNAME -name "*.conf") ######################################"
	GRBALL="AS1CZT_"$GRBNAME"_ALL"
	GRB10SECBIN="AS1CZT_"$GRBNAME"_10SECBIN"
	GRB1SECBIN="AS1CZT_"$GRBNAME"_1SECBIN"
	GRBpoint1SECBIN="AS1CZT_"$GRBNAME"_0.1SECBIN"
	GRBVeto="AS1CZT_"$GRBNAME"_Veto"

	echo "####################################  Genrating CZT Light Curve #############################################"
	echo "#####Genrating CZT Light Curve ::" >>$grblogs
	echo "`echo -e ' \t'`" >>$grblogs



   	 trans_det.py $evtfile_up $products/$GRBALL --tmark $tmark
	trans_det.py $evtfile_up $products/$GRB10SECBIN --tmark $tmark  --tmin `echo "$tmark-500"|bc -l` --tmax `echo "$tmark+500"|bc -l` --tbin 10
	trans_det.py $evtfile_up $products/$GRB1SECBIN --tmark $tmark  --tmin `echo "$tmark-100"|bc -l` --tmax `echo "$tmark +100"|bc -l` --tbin 1
	trans_det.py $evtfile_up $products/$GRBpoint1SECBIN --tmark $tmark  --tmin `echo "$tmark-20"|bc -l` --tmax `echo "$tmark + 20"|bc -l` --tbin 0.1
    
	echo "trans_det.py $evtfile_up $products/$GRBALL --tmark $tmark">>$grblogs
	echo "trans_det.py $evtfile_up $products/$GRB10SECBIN --tmark $tmark  --tmin `echo "$tmark-500"|bc -l` --tmax `echo "$tmark+500"|bc -l` --tbin 10">>$grblogs
	echo "trans_det.py $evtfile_up $products/$GRB1SECBIN --tmark $tmark  --tmin `echo "$tmark-100"|bc -l` --tmax `echo "$tmark +100"|bc -l` --tbin 1">>$grblogs
    	echo "trans_det.py $evtfile_up $products/$GRBpoint1SECBIN --tmark $tmark  --tmin `echo "$tmark-20"|bc -l` --tmax `echo "$tmark + 20"|bc -l` --tbin 0.1">>$grblogs



	echo :"###################################  Generating Veto Light Curve ############################################"
	echo "#####Generating Veto Light Curve ::" >>$grblogs
	echo "`echo -e ' \t'`" >>$grblogs

    	 Veto_new.py $mkffile $products/$GRBVeto --tmark $tmark --tmin `echo "$tmark-150"|bc -l`  --tmax `echo "$tmark+150"|bc -l` #$GRBNAME  
     	echo "gen_vetolightcurve.py $mkffile $GRBNAME $products --tmark $tmark --tmin `echo "$tmark-150"|bc -l`  --tmax `echo "$tmark+150"|bc -l`" >>$grblogs

    


	echo "###################################  Generating offaxis products #############################################"
	echo "#####Generating offaxis products::" >>$grblogs
	echo "`echo -e ' \t'`" >>$grblogs
 
      	offaxispos.py $confile --noloc
      	echo "offaxispos.py $confile --noloc" >>$grblogs



	echo "###################################  Evaluate the grb parameters for web updates ##############################"
	echo "#####Evaluate the grb parameters for web updates ::" >>$grblogs
	echo "`echo -e ' \t'`" >>$grblogs


   	echo "Web_grbpara.py $GRBNAME $orbit_num $mkffile --tmark $tmark --RA $RA --DEC $DEC>>/data2/czti/special/GRBParalist.txt" >>$grblogs
   	Web_grbpara.py $GRBNAME $orbit_num $mkffile --tmark $tmark --RA $RA --DEC $DEC



	echo "###################################  Trimmig the file for future references  ####################################"
	echo "###### Trimmig the file for future references::" >>$grblogs
	echo "`echo -e ' \t'`" >>$grblogs

     	python /home/cztipoc/czti_svn/trunk/users/vedants/bash_codes/grb_pipeline/trimgrbfile.py $evtfile_up $evtfile_up_1200sec --tmin `echo "$tmark-600"|bc -l` --tmax `echo "$tmark+600"|bc -l` --noe 5
    	 python /home/cztipoc/czti_svn/trunk/users/vedants/bash_codes/grb_pipeline/trimgrbfile.py $attfile_up $attfile_up_1200sec --tmin `echo "$tmark-600"|bc -l` --tmax `echo "$tmark+600"|bc -l` --noe 1
     	python /home/cztipoc/czti_svn/trunk/users/vedants/bash_codes/grb_pipeline/trimgrbfile.py $orbfile_up $orbfile_up_1200sec --tmin `echo "$tmark-600"|bc -l` --tmax `echo "$tmark+600"|bc -l` --noe 1
 
    	 echo "python /home/cztipoc/czti_svn/trunk/users/vedants/bash_codes/grb_pipeline/trimgrbfile.py $evtfile_up $evtfile_up_1200sec --tmin `echo "$tmark-600"|bc -l` --tmax `echo "$tmark+600"|bc -l` --noe 5" >>$grblogs
    	 echo "python /home/cztipoc/czti_svn/trunk/users/vedants/bash_codes/grb_pipeline/trimgrbfile.py $attfile_up $attfile_up_1200sec --tmin `echo "$tmark-600"|bc -l` --tmax `echo "$tmark+600"|bc -l` --noe 1" >>$grblogs
    	 echo "python /home/cztipoc/czti_svn/trunk/users/vedants/bash_codes/grb_pipeline/trimgrbfile.py $orbfile_up $orbfile_up_1200sec --tmin `echo "$tmark-600"|bc -l` --tmax `echo "$tmark+600"|bc -l` --noe 1" >>$grblogs

	 delete_auxfile=$(find $aux/ -name "*level1.att"  -o -name "*level1.orb")
	 delete_evtfile=$(find $modeM0_up/ -name "*level2_quad_clean.evt")
     	#rm -rf $delete_evtfile $delete_auxfile
 

	echo "####################################  Calculating Theta Values ###########################"
	echo "################# Calculation of theta values ">>	echo "`echo -e ' \t'`" >>$grblogs
	OUTPUT=($(python Theta_values_calculation.py $mkffile $Astrosat_seconds | tr -d '[],'))
	arg1=`printf "%.5f" ${OUTPUT[0]}`
	arg2=`printf "%.5f" ${OUTPUT[1]}`
	arg3=`printf "%.5f" ${OUTPUT[2]}`
	echo $arg1
	echo $arg2
	echo $arg3
	ch=1
        radec2CZTI<<EOF 
	$ch
	$arg1, $arg2, $arg3
	$RA, $DEC
EOF
echo "Astrosat seconds:$Astrosat_seconds"
 
else 
	echo "Trigger Time:$Astrosat_seconds is present in Data Gap"
fi
	

#!/bin/bash
#Finding_orbit.sh
#Priyanka Shahane,
#09 Dec 2017
#Script takes UTC time and gives orbit path containing that time 
#INPUt:UTC Time
#OUTPUT:Orbit path with OBSID
#Example:./Finding_orbit.sh 2017-01-21 14:44:22.410
############################################################################################################################################
date=$1
time=$2
FILETYPE='header.LOG'
workdir=/data2/czti/local_level2/
#dir=/data2/czti/testarea/badpix
string3=`echo $date $time`
#echo $date,$time
for file in /data2/czti/local_level2/*    
do 
 	#echo $var 
	var=`echo $file|grep -v SLEW`
	if [ ! -z $var ];then
	f1=$(basename $var)
		Year_month_file=`echo $f1|cut -d '_' -f 1|head -c 6`
		Year_month_input=`echo $date | sed 's/[^a-zA-Z0-9]//g'|head -c 6`
		Year=`echo $date | sed 's/[^a-zA-Z0-9]//g'|head -c 4`
	        month=`echo -n $Year_month_input |tail -c 2`
		if [[ "$month" == "01" ]];then
		     Year_new=`echo "$(($Year - 1))"`
		     Year_month_new=$Year_new"12"		     
		fi
		  	flag=0		
		if [[ "$Year_month_file" == "$Year_month_input" ]];then
			for f in $var/czti/orbit/*    
                         do
                         #echo "in orbit"
                          # echo $f
                           if [ -f $f/html/$FILETYPE ]; then
        	           FILE1=`find $f/html -name $FILETYPE`
        	          
                      					date2=`cat $FILE1|grep "date-obs:"`
                     					date3=`cat $FILE1|grep "date-end:"`
                     					d2=`echo $date2 |cut -d ':' -f 2|cut -d ' ' -f 2` 
                     					d3=`echo $date3 |cut -d ':' -f 2|cut -d ' ' -f 2` 
                     					time1=`cat $FILE1|grep "time-obs:"|cut -c 11-28`
         						time2=`cat $FILE1|grep "time-end:"|cut -c 11-28`
         						#echo $time1
         						#echo $time2
         						string_to_replace_with=':'
							time1_1="${time1//-/$string_to_replace_with}"
							time2_1="${time2//-/$string_to_replace_with}"
							#echo $time1_1
							#echo $time2_1
         						dldate="$(date -d "$d2" +"%Y-%m-%d")"
							dltime="$(date -d "$time1_1" +"%H:%M:%S")" 
							
							string="${dldate} ${dltime}"
							dldate="$(date -d "$d3" +"%Y-%m-%d")"
							dltime="$(date -d "$time2_1" +"%H:%M:%S")"
							#echo $dltime
							string1="${dldate} ${dltime}"
						if [[ "$(date --date="$string3" +%s)" -ge "$(date --date="$string" +%s )" ]] && [[ "$(date --date="$string1" +%s)" -ge "$(date --date="$string3" +%s)" ]] ;then
                					orbit=$(basename $f)
                    					if [ "$flag" -eq "0" ];then
                         					StartDate=$(date -u -d "$time" +"%s.%N")
                         					FinalDate=$(date -u -d "$time2" +"%s.%N")
                         					Time=`date -u -d "0 $FinalDate sec - $StartDate sec" +"%H:%M:%S.%N"`
                         					flag=1
                         					orbit1=$orbit
                         					OBSID1=$f1
                         					#echo $orbit
                         				else
                         					StartDate=$(date -u -d "$time" +"%s.%N")
                         					FinalDate=$(date -u -d "$time2" +"%s.%N")
                         					Time1=`date -u -d "0 $FinalDate sec - $StartDate sec" +"%H:%M:%S.%N"`
                         					orbit2=$orbit
                         					OBSID2=$f1
                         					flag=0
                    					fi
                    					#echo /data2/czti/level2/$f1/czti/orbit/$orbit1
                                                         #exit;
            					fi
           				 fi
        done
		
		else
		 #echo "in else"
		# echo $Year_month_new
		    if [[ "$Year_month_file" == "$Year_month_new" ]];then
		    		for f in $var/czti/orbit/*    
                                do
                                #echo "in 201612"
                #echo $f
        	FILE1=`find $f/html -name $FILETYPE`
        	if [ ! -z $FILE1 ]; then
                      					date2=`cat $FILE1|grep "date-obs:"`
                     					date3=`cat $FILE1|grep "date-end:"`
                     					d2=`echo $date2 |cut -d ':' -f 2|cut -d ' ' -f 2`
                     					d3=`echo $date3 |cut -d ':' -f 2|cut -d ' ' -f 2`
                     					time1=`cat $FILE1|grep "time-obs:"|cut -c 11-28`
         						time2=`cat $FILE1|grep "time-end:"|cut -c 11-28`
         						dldate="$(date -d "$d2" +"%Y-%m-%d")"
							dltime="$(date -d "$time1" +"%H:%M:%S")"
							string="${dldate} ${dltime}"
							dldate="$(date -d "$d3" +"%Y-%m-%d")"
							dltime="$(date -d "$time2" +"%H:%M:%S")"
							string1="${dldate} ${dltime}"
						if [[ "$(date --date="$string3" +%s)" -ge "$(date --date="$string" +%s )" ]] && [[ "$(date --date="$string1" +%s)" -ge "$(date --date="$string3" +%s)" ]] ;then
                					orbit=$(basename $f)
                    					if [ "$flag" -eq "0" ];then
                         					StartDate=$(date -u -d "$time" +"%s.%N")
                         					FinalDate=$(date -u -d "$time2" +"%s.%N")
                         					Time=`date -u -d "0 $FinalDate sec - $StartDate sec" +"%H:%M:%S.%N"`
                         					flag=1
                         					orbit1=$orbit
                         					OBSID1=$f1
                         					
                         					#echo /data2/czti/level2/$f1/czti/orbit/$orbit1
                         				else
                         					StartDate=$(date -u -d "$time" +"%s.%N")
                         					FinalDate=$(date -u -d "$time2" +"%s.%N")
                         					Time1=`date -u -d "0 $FinalDate sec - $StartDate sec" +"%H:%M:%S.%N"`
                         					orbit2=$orbit
                         					OBSID2=$f1
                         					flag=0
                    					fi
                                                         #exit;
            					fi
           				 fi
        done
		    fi
        		
                fi 
                fi		
done	
if [ "$(date --date="$Time" +%s)" -gt  "$(date --date="$Time1" +%s)" ];then
	if [  -d /data2/czti/level2/$OBSID1/czti/orbit/$orbit1 ]; then
		echo /data2/czti/level2/$OBSID1/czti/orbit/$orbit1
	else
		echo "DataGap ...Orbit is not on DQR..!"
	fi
else
	if [  -d /data2/czti/level2/$OBSID2/czti/orbit/$orbit2 ]; then
		echo /data2/czti/level2/$OBSID2/czti/orbit/$orbit2
	else
		echo "DataGap ...Orbit is not on DQR..!"
	fi
        
fi

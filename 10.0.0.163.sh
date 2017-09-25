#!/bin/bash
#
#to use this tcript you must install rsync and cifs-utils
#
#script for local backup of mounted folders
#
#ALL MOUNTED FOLDERS YOU CAN SEE IN /etc/fstab
#mount dir is /mnt/windows_shares/*
#
#folder structure of all backup folders included in this backup script's:
#       |_/mnt/dane/
#       |_______/$SF_DIR/
#       |_______________/$SF_IP/
#       |______________________/$SF_SUMDIR/
#	|______________________________________/$PERV_MONTH
#       |______________________/$SF_MDIR/
#       |______________________________________/$SF_TODAY/
#       |_______/databases/
#       |_______/machine_configuration/

########################################################################################
#MAIN VARIABLES HERE!!! MAIN DIR'S HERE!!!					       #
########################################################################################
TODAY=$(date +%d)
YESTERDAY=$(date -d ' -1 day ' +%d)
PERV_MONTH=$(date -d "-1 month" +%m_%Y)
#change this if you wanna change host
IP="10.0.0.163"
#root dir
ROOT="/mnt/dane"
#############################
#PID_FILE                   #
#############################
PID_LOG="$ROOT/PID_LOG"
if ! [ -d $PID_LOG  ]; then
	echo "Pid and Log File Is Not Exists. Making $PID_LOG"
	mkdir $PID_LOG
fi
LOG_FILE="$PID_LOG/backup.log"
if ! [ -e $LOG_FILE  ]; then
	echo "Log File Is Not Exists. Makking $LOG_FILE"
	touch $LOG_FILE
fi
PID_FILE="$PID_LOG/backup.pid"
if [ -e $PID_FILE ]; then
if [ -z `ps ax | awk '{ print $1;}' | grep $PID_FILE`]; then
echo "Process $PID_FILE Died"
rm $PID_FILE
else
echo "Process $PID_FILE Still Working."
fi
fi
touch $PID_FILE
#############################
#$SF_DIR 		    #
#############################
SF_DIR="$ROOT/shared_files"
        if ! [ -d $SF_DIR ]; then
                echo "Main Directory Is Not Exists. Making  $SF_DIR">>$LOG_FILE
                mkdir $SF_DIR
        fi

#############################
#$SF_IP 		    #
#############################
SF_IP="$SF_DIR/$IP"
        if ! [ -d $SF_IP  ]; then
                echo "Ip Dir Is Not Exists. Making $SF_IP ">>$LOG_FILE
                mkdir $SF_IP
        fi
#############################
#$SF_SUMDIR		    #
#############################
#folder for compressed month backups
SF_SUMDIR="$SF_IP/compressed"
	if ! [ -d $SF_SUMDIR ]; then
        	echo "Sum Dir Is Not Exists. Making $SF_SUMDIR ">>$LOG_FILE
        	mkdir $SF_SUMDIR
	fi
#############################
#$SF_MDIR		    #
#############################
SF_MONTH=$(date +%F | awk -F- '{print $2"_"$1}')
SF_MDIR="$SF_IP/$SF_MONTH"
	if ! [ -d $SF_MDIR  ]; then
        	echo "Month Dir Is Not Exists. Making $SF_MDIR">>$LOG_FILE
        	mkdir $SF_MDIR
	fi
##############################
#SF_TODAY		     #
##############################
SF_TODAY="$SF_MDIR/$TODAY"
	if ! [ -d $SF_TODAY  ]; then
        	echo "Today's Dir Is Not Exists. Making $SF_TODAY">>$LOG_FILE
        	mkdir $SF_TODAY
        fi	
##########################################################################################
#FULLDAY										 #
##########################################################################################
if [ $TODAY -eq 1 ]; then
	start=$(date +%s)
        echo "Today is FULLDAY `date -%F`">>$LOG_FILE
	cd $SF_IP/$PERV_MONTH
	tar -czf $SF_SUMDIR/$PERV_MONTH.tar  ./*
	rm -rf $SF_MDIR/$PERV_MONTH
	cat /etc/fstab | grep $IP | awk '{print $2}'| while read list;do rsync -a  $list $SF_TODAY; done
        finish=$(date +%s)
	echo -e "`date` *** FULL worked for $((finish - start)) seconds">>$LOG_FILE
fi
##########################################################################################
#HARD LINK + INCREMENTAL FROM SRC						         #
##########################################################################################
if [ $TODAY -ne 1 ]; then
	echo "Today is EVERYDAY" >> $LOG_FILE
	start=$(date +%s)	
	cp --archive --link $SF_MDIR/$YESTERDAY $SF_TODAY  
	cat /etc/fstab | grep $IP | awk '{print $2}'| while read list;do rsync -auxz --delete  $list $SF_TODAY; done
	finish=$(date +%s) 
	echo -e "`date` *** INC worked for $((finish - start)) seconds">>$LOG_FILE
	
fi







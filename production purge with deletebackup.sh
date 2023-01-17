#!/bin/ksh

deletebackup() {
    folder_name=$1
    folder_path=$2
    delete_tar_gz=$3

    backup_folder_name="${folder_name%_ReadyToDelete}"
    backup_folder_name="$backup_folder_name.tar.gz"
    backup_folder="$BACKUP/$backup_folder_name"

echo "checking for $backup_folder_name in $BACKUP folder "

    if [[ -f $backup_folder ]]; then
        echo "$backup_folder is present"
        if [[ $delete_tar_gz = "Y" ]]; then
            rm -r $backup_folder
            echo "$backup_folder is deleted as backup found"
            rm -rf "$folder_path/$folder_name"
			echo "$folder_path/$folder_name is deleted"
        else
            echo "$backup_folder is found but flag is N hence exiting"
			exit
        fi
    else
	echo "$folder_path/$folder_name is deleted as  $BACKUP/$backup_folder_name is not found"
        rm -rf "$folder_path/$folder_name"
    fi
}

purgeandarch() {

	l_sourcefolder=$1
	l_sourcepath=$2
	l_retention=$3

	if [[ -z  $l_sourcefolder || -z $l_sourcepath || -z $l_retention ]] ; then
		echo "source folder is null hence exiting"
			exit
		else 
		continue
	fi

	if [[ $l_sourceFolder = "default" ]] ; then
		echo "source folder has default value hence exiting"
			exit
		else
		continue
	fi

	echo "Purging started for  $l_sourcefolder  from path = $l_sourcepath with retention of $l_retention"

	mkdir -p $TARBKP/${l_sourcefolder}_"$tgldat"

	export destination=$TARBKP/${l_sourcefolder}_"$tgldat"
	echo "dest is : $destination"

	##no of directories in source folder 
	echo "no of folder in source path" `find "${l_sourcepath}" -type d | wc -l`

	## Create empty folder structure at the tarbackup directory
	
	find $l_sourcepath -type d -exec sh -c 'for dir do
			mkdir -p  "${destination}/$dir"
	done' sh {} +

	echo "directory creation success. directories created : " `find "${destination}" -type d| wc -l`
	

	#no of files to be moved
	echo "no of files to be moved to target" `find $l_sourcepath  -type f -mtime +$l_retention | wc -l`
	
	##move files older than retention days to 
	find $l_sourcepath -type f -mtime +"$l_retention" -exec sh -c 'for file do
			mv "$file" "${destination}/$file"
	done' sh {} +

	echo "file movement completed. Total files created  :  " `find "${destination}" -type f| wc -l`
	
	echo "empty folder deletion for temp backup area started for ${destination}  "
	find ${destination} -type d |while read name
	do
		if (( $(ls -1 $name|wc -l) == 0 ))
		then
			#echo $name
			rmdir $name 
		fi
	done

	# doing the tar backup of the file moved to temporary area.
	/usr/bin/tar cf - ${destination} | /usr/contrib/bin/gzip -1 - > /backup/${l_sourcefolder}_"$tgldat".tar.gz
	
	echo "tar file with size "`find /backup/${l_sourcefolder}_"$tgldat".tar.gz -exec du -sk {} \;` " is created"
	
	echo "empty folder deletion started for ${l_sourcepath} "
	find ${l_sourcepath} -type d -mtime +"$l_retention" |while read name
	do
		if (( $(ls -1 $name|wc -l) == 0 ))
		then
			#echo $name
			rmdir $name 
		fi
	done
	
	###renaming temp folder to read to delete
	echo "renaming $destination" to ready to delete
	mv ${destination} ${destination}_"ReadyToDelete"
	
echo "##############################"


}

export tgldat=`date '+%Y'-'%m'-'%d'`
export TARBKP=<path of folder>Tarbackup
export destination=""
export BACKUP=/backup

DIRRPT=<path of folder>rptout
RJSIN=<path of folder>rjsin
RJSOUT=<path of folder>rjsout
DIRAUD1=<path of folder>audit
DIRAUD2=<path of folder>audit
DIRAUD3=<path of folder>audit
DIRAUD4=<path of folder>audit
DIRFCWSPRD1=<path of folder>FCWSPRD1
DIRFCWSPRD2=<path of folder>FCWSPRD2
DIRFCWSPRD3=<path of folder>FCWSPRD1
DIRFCWSPRD4=<path of folder>FCWSPRD2
DIRFEPI=<path of folder>FEPI
DIRFHM=<path of folder>FHM
DIRWASJVM=<path of folder>WASJVM
DIRWSFEPI=<path of folder>WSFEPI
DIRWSFHM=<path of folder>WSFHM
DIRfepi=<path of folder>fepi
ILREQBU=<path of folder>BackUp
ILRSPBU=<path of folder>BackUp
ILREQDM=<path of folder>Dump
ILRSPDM=<path of folder>Dump
ILREQEF=<path of folder>Error_Files
ILRSPEF=/<path of folder>Error_Files


DMB1PRD=<path of folder>Prod/DMB1
DMB2PRD=<path of folder>/DMB2
DMB3PRD=<path of folder>/DMB3
DMB4PRD=<path of folder>/DMB4
ILBIFAST01PRD=<path of folder>/ILBIFAST01
ILBIFAST02PRD=<path of folder>/ILBIFAST02
ILBIFAST03PRD=<path of folder>/ILBIFAST03
ILBIFAST04PRD=<path of folder>/ILBIFAST04
ILOMNI01PRD=<path of folder>/ILOMNI01
ILOMNI02PRD=<path of folder>/ILOMNI02
ILOMNI03PRD=<path of folder>/ILOMNI03
ILOMNI04PRD=<path of folder>/ILOMNI04
ILOMNI05PRD=<path of folder>/ILOMNI05
ILOMNI06PRD=<path of folder>/ILOMNI06
ILOMNI07PRD=<path of folder>/ILOMNI07
ILOMNI08PRD=<path of folder>/ILOMNI08
OC4J1PRD=<path of folder>/OC4J1
OC4J2PRD=<path of folder>/OC4J2
OC4J3PRD=<path of folder>/OC4J3
OC4J4PRD=<path of folder>/OC4J4
MIDTRANS1PRD=<path of folder>/MIDTRANS1
MIDTRANS2PRD=<path of folder>/MIDTRANS2
MIDTRANS3PRD=<path of folder>/MIDTRANS3
MIDTRANS4PRD=<path of folder>/MIDTRANS4



DMB1DRC=<path of folder>/DMB1
DMB2DRC=<path of folder>/DMB2
DMB3DRC=<path of folder>/DMB3
DMB4DRC=<path of folder>/DMB4
ILBIFAST01DRC=<path of folder>/ILBIFAST01
ILBIFAST02DRC=<path of folder>/ILBIFAST02
ILBIFAST03DRC=<path of folder>/ILBIFAST03
ILBIFAST04DRC=<path of folder>/ILBIFAST04
ILOMNI01DRC=<path of folder>/ILOMNI01
ILOMNI02DRC=<path of folder>/ILOMNI02
ILOMNI03DRC=<path of folder>/ILOMNI03
ILOMNI04DRC=<path of folder>/ILOMNI04
ILOMNI05DRC=<path of folder>/ILOMNI05
ILOMNI06DRC=<path of folder>/ILOMNI06
ILOMNI07DRC=<path of folder>/ILOMNI07
ILOMNI08DRC=<path of folder>/ILOMNI08
OC4J1DRC=<path of folder>/OC4J1
OC4J2DRC=<path of folder>/OC4J2
OC4J3DRC=<path of folder>/OC4J3
OC4J4DRC=<path of folder>/OC4J4
MIDTRANS1DRC=<path of folder>/MIDTRANS1
MIDTRANS2DRC=<path of folder>/MIDTRANS2
MIDTRANS3DRC=<path of folder>/MIDTRANS3
MIDTRANS4DRC=<path of folder>/MIDTRANS4
GCLOGS=<path of folder>/GCLogs



set -A sourcepathlist "DIRRPT" "RJSIN" "RJSOUT" "DIRAUD1" "DIRAUD2" "DIRAUD3" "DIRAUD4" "DIRFCWSPRD1" "DIRFCWSPRD2" "DIRFCWSPRD3" "DIRFCWSPRD4" "DIRFEPI" "DIRFHM" "DIRWASJVM" "DIRWSFEPI" "DIRWSFHM" "DIRfepi" "ILREQBU" "ILRSPBU" "ILREQDM" "ILRSPDM" "ILREQEF" "ILRSPEF" "DMB1PRD" "DMB2PRD" "DMB3PRD" "DMB4PRD" "ILBIFAST01PRD" "ILBIFAST02PRD" "ILBIFAST03PRD" "ILBIFAST04PRD" "ILOMNI01PRD" "ILOMNI02PRD" "ILOMNI03PRD" "ILOMNI04PRD" "ILOMNI05PRD" "ILOMNI06PRD" "ILOMNI07PRD" "ILOMNI08PRD" "OC4J1PRD" "OC4J2PRD" "OC4J3PRD" "OC4J4PRD" "MIDTRANS1PRD" "MIDTRANS2PRD" "MIDTRANS3PRD" "MIDTRANS4PRD" "DMB1DRC" "DMB2DRC" "DMB3DRC" "DMB4DRC" "ILBIFAST01DRC" "ILBIFAST02DRC" "ILBIFAST03DRC" "ILBIFAST04DRC" "ILOMNI01DRC" "ILOMNI02DRC" "ILOMNI03DRC" "ILOMNI04DRC" "ILOMNI05DRC" "ILOMNI06DRC" "ILOMNI07DRC" "ILOMNI08DRC" "OC4J1DRC" "OC4J2DRC" "OC4J3DRC" "OC4J4DRC" "MIDTRANS1DRC" "MIDTRANS2DRC" "MIDTRANS3DRC" "MIDTRANS4DRC" "GCLOGS" 
retentiongroup1="DMB1PRD DMB2PRD DMB3PRD DMB4PRD ILBIFAST01PRD ILBIFAST02PRD ILBIFAST03PRD ILBIFAST04PRD ILOMNI01PRD ILOMNI02PRD ILOMNI03PRD ILOMNI04PRD ILOMNI05PRD ILOMNI06PRD ILOMNI07PRD ILOMNI08PRD OC4J1PRD OC4J2PRD OC4J3PRD OC4J4PRD MIDTRANS1PRD MIDTRANS2PRD MIDTRANS3PRD MIDTRANS4PRD DMB1DRC DMB2DRC DMB3DRC DMB4DRC ILBIFAST01DRC ILBIFAST02DRC ILBIFAST03DRC ILBIFAST04DRC ILOMNI01DRC ILOMNI02DRC ILOMNI03DRC ILOMNI04DRC ILOMNI05DRC ILOMNI06DRC ILOMNI07DRC ILOMNI08DRC OC4J1DRC OC4J2DRC OC4J3DRC OC4J4DRC MIDTRANS1DRC MIDTRANS2DRC MIDTRANS3DRC MIDTRANS4DRC GCLOGS" 
retentiongroup2="DIRAUD1 DIRAUD2 DIRAUD3 DIRAUD4"
retentiongroup3="DIRFEPI DIRFHM DIRWASJVM DIRWSFEPI DIRWSFHM DIRfepi"
retentiongroup4="DIRRPT RJSIN RJSOUT ILREQBU ILRSPBU ILREQDM ILRSPDM ILREQEF ILRSPEF"
retentiongroup5="DIRFCWSPRD1 DIRFCWSPRD2 DIRFCWSPRD3 DIRFCWSPRD4"

retention=7
sourcefolder=default
sourcepath=default
for i in "${sourcepathlist[@]}";
	do
	    if [[ ! -z  `echo $retentiongroup1 | grep -w ${i}` ]] ; then
			retention=12
			echo "retention for ${i} is  $retention"

	    elif [[ ! -z  `echo $retentiongroup2 | grep -w ${i}` ]]; then
			retention=7
			echo "retention for ${i} is $retention"
		
		elif [[ ! -z  `echo $retentiongroup3 | grep -w ${i}` ]]; then
			retention=30
			echo "retention for ${i} is $retention"
			
		elif [[ ! -z  `echo $retentiongroup4 | grep -w ${i}` ]]; then
			retention=14
			echo "retention for ${i} is $retention"
		 
	    elif [[ ! -z  `echo $retentiongroup5 | grep -w ${i}` ]] ; then
			retention=10
			echo "retention for ${i} is $retention"
		 
	    else
			echo "no retention for "
			retention=7
			continue
	fi
	
	eval filepath=\$$i	
    #echo "${i} path is " "$filepath" " and retention period is $retention" ;
    sourcefolder="${i}"
    sourcepath="$filepath"
    
	
#checking if tar.gz file is present for the directory 

	echo "checking if tar.gz file is present for Source folder"

	readytodelete="$TARBKP/$sourcefolder*_ReadyToDelete"
	for folder in $readytodelete; do
		if [[ -d $folder ]]; then
			folder_name=$(basename $folder)
			folder_path=$(dirname $folder)
			deletebackup "$folder_name" "$folder_path" "Y"
		fi
	done

	
	#call business logic for movement
	purgeandarch "${sourcefolder}" "${sourcepath}" "${retention}"       

done

sleep 30
cd /backup
mv *_"$tgldat".tar.gz $BACKUP/

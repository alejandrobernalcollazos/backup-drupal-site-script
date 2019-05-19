#!/bin/bash

#Define date
CURRENT_DATE=`date +"%d-%b-%Y"`
RESULT_FOLDER=result-$CURRENT_DATE
DB_FILE=backup-db-$CURRENT_DATE
FILES=files-$CURRENT_DATE
TEMPORAL_DIRECTORY=backup
FILES_AND_DB=backup-files-and-db-$CURRENT_DATE

#Define the usage text
USAGE="
       $(basename "$0")

       Program to backup drupal website

       where:
         -h  show this help text
         -u  username of mysql database
         -p  password of mysql database
         -d  database of mysql to be backed up
         -f  folder that contains drupal files

       Sample Usage

         ./backup.sh -u user -p 1969 -d drupal -f /home/www-data/web
      "

#Parameters
#1 mysql user
#2 mysql user password
#3 mysql db to backup
#4 folder to backup

#Processing parameters
while getopts u:p:d:f:h option
do
  case "${option}"
  in
  h) echo "$USAGE"
     exit;;
  u) USER=${OPTARG};;
  p) USER_PASSWORD=${OPTARG};;
  d) DATABASE=${OPTARG};;
  f) FOLDER=${OPTARG};;
  esac
done

#Steps
#1 Create backup directory
mkdir $TEMPORAL_DIRECTORY

#2 Backup the database and set it within the backup directory
mysqldump -u$USER -p$USER_PASSWORD $DATABASE > $TEMPORAL_DIRECTORY/$DB_FILE.sql

#3 Backup the files and set them within the backup directory
tar -czf ./$TEMPORAL_DIRECTORY/$FILES.tar.gz -C $FOLDER .

#4 Tar the backup directory
tar -czf $FILES_AND_DB.tar.gz $TEMPORAL_DIRECTORY

#5 Delete the backup directory
rm -rf $TEMPORAL_DIRECTORY

#6 Create result directory
mkdir $RESULT_FOLDER

#7 Move the backup into the result directory
mv $FILES_AND_DB.tar.gz $RESULT_FOLDER

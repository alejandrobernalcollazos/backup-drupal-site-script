#!/bin/bash

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
mkdir backup

#2 Backup the database and set it within the backup directory
mysqldump -u$USER -p$USER_PASSWORD $DATABASE > backup/drupal.db

#3 Backup the files and set them within the backup directory
tar -czf ./backup/backup-files.tar.gz -C $FOLDER .

#4 Tar the backup directory
tar -czf backup-files-and-db.tar.gz backup

#5 Delete the backup directory
rm -rf backup

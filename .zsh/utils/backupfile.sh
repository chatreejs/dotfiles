#!/bin/sh

BACKUP_FILE=$1
DATE=$(date +%Y%m%d%H%M%S)

if [ -z ${BACKUP_FILE} ]
then
  echo "Invalid : Please specify file to backup."
  echo "Ex. backupfile /tmp/test.sh"
  exit 1;
fi

cp -p ${BACKUP_FILE} ${BACKUP_FILE}.${DATE}
ls -l ${BACKUP_FILE} ${BACKUP_FILE}.${DATE}
echo "File backup : ${BACKUP_FILE} done"
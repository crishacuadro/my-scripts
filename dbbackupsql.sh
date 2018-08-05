#!/bin/bash
#dbbackupsql.sh
sqldb_host"localhost"
sqldb_user="root"
sqldb_pw=""
sqldb_dumpdir="/opt/dump-backup"
sqldb_sourcedir="/var/lib/mysql/"
timestamp="date +%Y_%m_%d_%H_%M"
sqldb_label="mportant_files"
min_old="15"

#this part automatically logs in the user
  echo "Signing up mysql user.."

  if [$mysql_pw]
  then
    mysql -h -u "$sqldb_user" -p "$mysql_pw" -e "SHOW DATABASES;"
  else
    mysql -u "$sql_user" -e "SHOW DATABASES"
  fi

#checks for the backup directory
  if [ ! -e "$sqldb_dumpdir" ];
  then
    echo "Backup directory already exist. $sqldb_dumpdir"
  else
    mkdir -p $sqldb_dumpdir
    echo "Directory created for database backup. $sqldb_dumpdir"
  fi

#this part creates && compress backup for the database
  echo "Creating Backup for $sqldb_label"

  for ((i=0;i<$sqldb_label;i++)); do
  do
    mysqldump -h "$sqldb_host" -u "$sql_user" -p "$sqldb_pw" ${sqldb_label[$i]} > $sqldb_sourcedir/${sqldb_label[$i]}-MySQL-backup-$timestamp.sql
  done

  echo "Compressing Databases..."
  cd $sqldb_sourcedir// && tar -czf $sqldb_dumpdir/$sqldb_label-$timestamp.tar.gz *.sql

#this part backups the database every 5mins using crontab
  #
#this part deletes older backups
  echo "Deleting backups older than $min_old minutes..."
  find $sqldb_dumpdir/$sqldb_label*.tar.gz -mmin +$min_old -exec rm {} \;
  echo "Done."

#!/bin/bash
#dbbackupsql.sh

#this part automatically logs in the user
sqldb_user="root"
sqldb_pw=""

dbsql_checklogin()
{
  if [${mysql_pw}]
  then
    mysql -u "${sqldb_user}" -p "${mysql_pw}" -e "SHOW DATABASES;"
  else
    mysql -u "${sql_user}" -e "SHOW DATABASES"
  fi
}

#magical pathz
sqldb_dumpdir="/opt/dump-backup"
sqldb_sourcedir="/var/lib/mysql/"

#checks for the backup directory
  if [ ! -e "${sqldb_dumpdir}" ];
  then
    echo "Backup directory exist ${sqldb_dumpdir}!"
  else
    mkdir -p ${sqldb_dumpdir}
    echo "Directory created for database backup!: ${sqldb_dumpdir}"
  fi

#this part creates backup for the database
timestamp="date +%Y_%m_%d_%H_%M"
sqldb_label="important_files"

  echo "Creating Backup.."
  for ${sqldb_label} in ${sqldb_sourcedir};
  do
    echo " - $sqldb_label"
    mysqldump --user=${sql_user} --password=${sqldb_pw} ${sqldb_label} > ${sqldb_dumpdir}/${sqldb_label}-MySQL-backup-${timestamp}.sql
  done
  echo "Backup for database is successfull"
#this part backups the database every 5mins using crontab

#this path backups the dump directory

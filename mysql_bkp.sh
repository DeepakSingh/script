now="$(date +'%Y%m%d_%H_%M_%S')"
filename="pos_disp_db".sql
foldername="bkp_mysql_$now"
logfilepath="/home/ubuntu/Projects/bkp_log_files/"
backupfolder="/home/ubuntu/Projects/db_bkp/mysql/"
logfile="$logfilepath"bkp_mysql_log_"$now".txt

username="pos_dbUser"
password="db@Pos@!1318!"

cd $backupfolder
mkdir $foldername
fullpathbackupfile="$backupfolder$foldername"

#cd $fullpathbackupfile

echo "mysqldump for pos_disp_db started" >> "$logfile"
mysqldump --user=$username --password=$password pos_disp_db > "$fullpathbackupfile/$filename"
echo "mysqldump for pos_disp_db finished" >> "$logfile"

filename="pos_demo_disp".sql
echo "mysqldump for pos_demo_disp started" >> "$logfile"
mysqldump --user=$username --password=$password pos_demo_disp > "$fullpathbackupfile/$filename"
echo "mysqldump for pos_demo_disp finished" >> "$logfile"


chown ubuntu "$fullpathbackupfile"
chown ubuntu "$logfile"
echo "file permission changed" >> "$logfile"

echo "file transer to db server starts" >> "$logfile"
sudo scp -r -i /home/ubuntu/keys/Backup.pem $fullpathbackupfile/ ubuntu@34.211.149.8:/home/ubuntu/db_backup/pos/Qa/mysql

echo "operation finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
echo "*****************" >> "$logfile"

echo "keeping the last 7 days backup file"
sudo find "$backupfolder" -type d -ctime +7 -exec rm -rf {} \;

echo "keeping the last 7 days logfile"
sudo find "$logfile" -type f -ctime +7 -exec rm -rf {} \;
exit 0

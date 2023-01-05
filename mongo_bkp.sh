now="$(date +'%Y%m%d_%H_%M_%S')"
foldername="bkp_mongo_$now"
logfilepath="/home/ubuntu/Projects/bkp_log_files/"
backupfolder="/home/ubuntu/Projects/db_bkp/mongo/"
logfile="$logfilepath"bkp_mongo_log_"$now".txt

username="posUser"
password="pos@user@!1318!"

cd $backupfolder
mkdir $foldername
fullpathbackupfile="$backupfolder$foldername"

cd $fullpathbackupfile
mkdir pos_disp_db
cd pos_disp_db

echo "mongo dump for pos_disp_db started" >> "$logfile"
mongodump -d pos_disp_db --username $username --password $password --authenticationDatabase admin
echo "mongo dump for pos_disp_db finished" >> "$logfile"

chown ubuntu "$fullpathbackupfile"
chown ubuntu "$logfile"
echo "file permission changed" >> "$logfile"


cd $fullpathbackupfile
mkdir pos_demo_disp
cd pos_demo_disp

echo "mongo dump for pos_demo_disp started" >> "$logfile"
mongodump -d pos_demo_disp --username $username --password $password --authenticationDatabase admin
echo "mongo dump for pos_demo_disp finished" >> "$logfile"

echo "file transer to db server starts" >> "$logfile"
sudo scp -r -i /home/ubuntu/keys/Backup.pem $fullpathbackupfile/ ubuntu@34.211.149.8:/home/ubuntu/db_backup/pos/Qa/mongo
echo "operation finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
echo "*****************" >> "$logfile"

echo "keeping the last 7 days backup file"
sudo find "$backupfolder" -type d -ctime +7 -exec rm -rf {} \;
exit 0

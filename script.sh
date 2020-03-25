#!/bin/bash

apt-get update
apt-get install wget -y
wget -O- -q http://s3tools.org/repo/deb-all/stable/s3tools.key | apt-key add -
wget -O/etc/apt/sources.list.d/s3tools.list http://s3tools.org/repo/deb-all/stable/s3tools.list
apt-get install s3cmd -y

# Set vars
mongo admin --eval "printjson(db.fsyncLock())"
MONGODUMP_PATH="/usr/bin/mongodump"
TIMESTAMP=`date +%F-%H%M`
S3_BUCKET_PATH="mongodb-backups"

MONGO_DATABASE="DATABASE NAME" # Replace with database name
S3_BUCKET_NAME="S3 BUCKET NAME" # Replace with S3 bucket name
COLLECTIONS=("foo" "bar") # Add collections from database in the array

for i in "${COLLECTIONS[@]}"
do

	# Create dump
	$MONGODUMP_PATH -d $MONGO_DATABASE -c $i

	# Add timestamp and tar dump
	mv dump mongodb-$i-$TIMESTAMP
	tar cf mongodb-$i-$TIMESTAMP.tar mongodb-$i-$TIMESTAMP

	# Upload to S3
	s3cmd put mongodb-$i-$TIMESTAMP.tar s3://$S3_BUCKET_NAME/$S3_BUCKET_PATH/mongodb-$i-$TIMESTAMP.tar

	#Unlock database writes
	mongo admin --eval "printjson(db.fsyncUnlock())"

	#Delete local files
	rm -rf mongodb-*

done


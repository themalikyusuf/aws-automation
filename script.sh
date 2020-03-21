#!/bin/bash

##########
# This is already automated with cloudforation
##########
# apt-get update
# apt-get install wget -y
# wget -O- -q http://s3tools.org/repo/deb-all/stable/s3tools.key | apt-key add -
# wget -O/etc/apt/sources.list.d/s3tools.list http://s3tools.org/repo/deb-all/stable/s3tools.list
# apt-get install s3cmd -y

##########
# Run the command below to configure s3cmd. Enter aws access/secret key: create access/secret key under the mongodb user in IAM. Region: us-east-2
##########
# s3cmd --configure

# Set vars
mongo admin --eval "printjson(db.fsyncLock())"
MONGODUMP_PATH="/usr/bin/mongodump"
TIMESTAMP=`date +%F-%H%M`
S3_BUCKET_PATH="mongodb-backups"

MONGO_DATABASE="DATABASE NAME" # Replace with database name
S3_BUCKET_NAME="S3 BUCKET NAME" # Replace with bucket name on S3
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

#########
# Run the cron job command to set up back for 02:00 daily(Note timezones)
#########
# 00 02 * * * /mongodb.sh


# Reference: https://medium.com/@bansalnagesh/backing-up-mongodb-on-aws-ec2-to-s3-b045b5727fd6
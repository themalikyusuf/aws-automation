#!/bin/bash

INSTANCE_ID=""
VOLUME_ID=""
SNAPSHOT_DESCRIPTION=""
VOLUME_TYPE=""
NEW_VOLUME_SIZE=

aws ec2 stop-instances --instance-ids $INSTANCE_ID

aws ec2 create-snapshot --volume-id $VOLUME_ID --description $SNAPSHOT_DESCRIPTION

aws ec2 modify-volume --volume-type $VOLUME_TYPE --size $NEW_VOLUME_SIZE --volume-id $VOLUME_ID

sleep 120

aws ec2 start-instances --instance-ids $INSTANCE_ID
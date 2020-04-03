#!/bin/bash

# Temp

aws ec2 stop-instances --instance-ids i-1234567890abcdef0

aws ec2 create-snapshot --volume-id vol-1234567890abcdef0 --description 'Prod backup' --tag-specifications 'ResourceType=snapshot,Tags=[{Key=purpose,Value=prod},{Key=costcenter,Value=123}]'

aws ec2 modify-volume --volume-type io1 --iops 10000 --size 200 --volume-id vol-11111111111111111 


how to run this from outside the instance: sudo resize2fs /dev/sda1


# Stop instance
# Snapshot
# Modify
# Extend

# Inform P

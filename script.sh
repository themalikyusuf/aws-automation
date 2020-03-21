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
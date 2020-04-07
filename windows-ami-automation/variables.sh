#!/bin/bash

ADMIN_PASSWORD=""
AWS_ACCESS_KEY=""
AWS_SECRET_KEY=""

sed -i "" -e "s/ADMIN_PASSWORD/$ADMIN_PASSWORD/g" template.json
sed -i "" -e "s/AWS_ACCESS_KEY/$AWS_ACCESS_KEY/g" template.json
sed -i "" -e "s/AWS_SECRET_KEY/$AWS_SECRET_KEY/g" template.json

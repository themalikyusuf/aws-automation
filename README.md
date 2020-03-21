# mongodb-s3-backup

##### Requirements
  - AWS access and secret keys for the 'mongodb' user. This can be created in the Identity and Access Management(IAM) page on AWS's console. The 'mongodb' user has been given full programmatic access to S3(Where the backup will be store)
 
##### Note
- The required tools for this script(s3cmd and wget) have already been installed on the MongoDB server as part of the CloudFormation script.
- Before running this script, enter the command below to configure `s3cmd` and follow the prompt to input the AWS access/secret keys. Enter **us-east-2** as the region.

```
$ s3cmd --configure
```
##### Running The Script:

Before running the script, ensure to have the appropriate variables in the file i.e.
- COLLECTIONS
- S3_BUCKET_NAME
- MONGO_DATABASE
```
$ ./mongodb.sh
```
Also, ensure to set a cron job as described at the end of script.

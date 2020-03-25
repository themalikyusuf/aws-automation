## mongodb-s3-backup
A Shell script that backs up MongoDB on AWS EC2 to S3.

##### Requirements
  - AWS access and secret keys with full programmatic access to S3. Get them from [IAM](https://console.aws.amazon.com/iam).

##### Prerequisites
Replace the following dummy variables in the `script.sh` file:
- COLLECTIONS
- S3_BUCKET_NAME
- MONGO_DATABASE

##### How to use
From the root directory:
```
$ ./script.sh
```

##### Credit
[Nagesh Bansal](https://medium.com/@bansalnagesh/backing-up-mongodb-on-aws-ec2-to-s3-b045b5727fd6)

## modify-ebs-volume
A Shell script that stops an EC2 instance and takes a snapshot of it's root ebs volume, modifies the size and extends the filesystem.


aws cli prepreqs

#### Requirements
  - Installation and configuration of [AWS CLI](https://docs.aws.amazon.com/cli/index.html).

#### Prerequisites
Replace the following dummy variables in the `script.sh` file:
- INSTANCE_ID
- VOLUME_ID
- SNAPSHOT_DESCRIPTION
- VOLUME_TYPE
- NEW_VOLUME_SIZE

#### How to use
From the root directory:
```
$ ./script.sh
```
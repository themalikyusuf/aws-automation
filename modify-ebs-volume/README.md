## modify-ebs-volume
This Bash script stops an EC2 instance, takes a snapshot of it's root EBS volume, modifies the size of the EBS volume and restarts the EC2 instance.

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

NB: After modification, you have to [extend](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html) the file system.

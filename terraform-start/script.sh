#!/bin/bash
set -e

# variables
projectdir="terraform-project"
main="$projectdir/main.tf"
ignore="$projectdir/.gitignore"

echo What provider do you want to initilize Terraform with? [aws, google, azurerm]

read cloudprovider

# check if user entered provider
if [ -z $cloudprovider ]
then
	echo You have not entered a provider. Terraform will be initialized without a provider.
else
	echo Creating project directory and initializing Terraform with "$cloudprovider" provider.
fi

# create project directory and files
mkdir $projectdir
touch $projectdir/{{main,output,variables}.tf,.gitignore}

# add contents to project files
cat <<EOM >$main
provider "$cloudprovider" {
	profile = profile
  region  = region
}

EOM

cat <<EOM >$ignore
# Local .terraform directories
**/.terraform/*

# .tfstate files
*.tfstate
*.tfstate.*

# Crash log files
crash.log

# Ignore any .tfvars files that are generated automatically for each Terraform run. Most
# .tfvars files are managed as part of configuration and so should be included in
# version control.
#
# example.tfvars

# Ignore override files as they are usually used to override resources locally and so
# are not checked in
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Include override files you do wish to add to version control using negated pattern
#
# !example_override.tf

# Include tfplan files to ignore the plan output of command: terraform plan -out=tfplan
# example: *tfplan*

# Ignore CLI configuration files
.terraformrc
terraform.rc

EOM

# initial the project
# cd $projectdir && terraform init

echo Project directory created and Terraform initialized.

# TODO
# check if project file name exists
# without enterring provider means not initialize? test initliaze without provider


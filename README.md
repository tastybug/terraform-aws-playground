# Terraform AWS Playground

Simple test project that uses Terraform to provision 2 EC2 instances (in parallel) on AWS. 

Further read at https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180.

# Preparations

Make sure docker and `awscli` is installed and there is an aws account that is able to create EC2 instances (policy `AmazonEC2FullAccess` will do the trick).
This project assumes that you have `~/.aws/credentials` in place with a single account. If you have more accounts in `credentials`, the env variable substitution will fail.


## Running

```
cd terraform-aws-playground
export AWS_ACCESS_KEY_ID=$(cat ~/.aws/credentials | grep "^aws_access.*" | sed 's/[\na-z_ =]*//')
export AWS_SECRET_ACCESS_KEY=$(cat ~/.aws/credentials | grep "^aws_secret.*" | sed 's/[\na-z_ =]*//')
export AWS_DEFAULT_REGION="us-east-1"

# have terraform download providers, e.g. the one for AWS access
docker run -i -t \
-v $PWD:$PWD \
-w $PWD \
hashicorp/terraform:light init -input=false

# see what the change will bring
docker run -i -t \
-v $PWD:$PWD \
-w $PWD \
--env AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
--env AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
--env AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
hashicorp/terraform:light plan

# apply the changes
docker run -i -t \
-v $PWD:$PWD \
-w $PWD \
--env AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
--env AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
hashicorp/terraform:light apply

# verify with awscli (make sure to point to the right region here)
aws ec2 describe-instances | jq ".Reservations[].Instances[].State" 

# remove everything
docker run -i -t \
-v $PWD:$PWD \
-w $PWD \
--env AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
--env AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
hashicorp/terraform:light destroy

# make sure everything is cleaned up again
aws ec2 describe-instances | jq ".Reservations[].Instances[].State" 

# remove local TF cache
git clean -f -d
```

#!/bin/bash
set -e

bucket_region='us-west-2'
bucket_name='vamshi-terraform1'

function usage() {
  echo "Usage: terraform.sh [action]"
  echo
  echo "action:"
  echo " - plan"
  echo " - apply"
  echo " - plan-destroy"
  echo " - destroy"
}

# Ensure script console output is separated by blank line at top and bottom to improve readability
trap echo EXIT
echo

# Validate the input arguments
if [ "$#" -ne 1 ]; then
  usage
  exit 1
fi

action="$1"

case "$action" in
  plan) ;;
  apply) ;;
  plan-destroy) ;;
  destroy) ;;
  *)
    usage
    exit 1
esac

if [ "$action" == "plan-destroy" ]; then
  action="plan"
  destroy="-destroy"
fi

if [ "$action" == "destroy" ]; then
  destroy='-destroy'
  force='-force'
fi

# Clear the .terraform directory (we want to pull the state from the remote)
rm -rf ".terraform"

bucket_exists() {
  if aws s3 ls "s3://$bucket_name" 2>&1 | grep -q "NoSuchBucket"
  then 
    echo "Bucket does not exist"
    return 0
  else 
    echo "Bucket exists"
    return 1
  fi
}

create_bucket() {
  echo "creating Bucket"
  aws s3 mb s3://$bucket_name && echo "Created S3 bucket, $bucket_name." >&2
}

# Configure remote state storage
echo "bucket exits?:"
echo $?
if bucket_exists
then
  create_bucket
fi

terraform remote config \
    -backend=S3 \
    -backend-config="region=$bucket_region" \
    -backend-config="bucket=$bucket_name" \
    -backend-config="key=terraform.tfstate"

# Plan
if [ "$action" == "plan" ]; then
  # Output a plan
  terraform plan \
    -input=false \
    -refresh=true \
    -module-depth=-1 \
    $destroy
  exit 0
fi

# Execute the terraform action
terraform "$action" \
  -input=false \
  -refresh=true \
  $force


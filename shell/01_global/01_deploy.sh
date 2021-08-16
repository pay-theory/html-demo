#!/usr/bin/env bash

PARTNER=$1
STAGE=$2
SERVICE_TYPE=$3
SERVICE_NAME=$4


echo "Validating the cfn templates `date` in `pwd`" ;
sam validate -t ./templates/global.yml ;
echo "Starting SAM build `date` in `pwd`" ;

sam deploy --template-file ./templates/global.yml \
--stack-name pt-account-${SERVICE_NAME} \
--region ${TARGET_REGION} \
--capabilities CAPABILITY_IAM \
--no-fail-on-empty-changeset
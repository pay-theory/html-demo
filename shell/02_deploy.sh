#!/usr/bin/env bash

PARTNER=$1
STAGE=$2
SERVICE_NAME=$3
SERVICE_TYPE=$4

S3_ARTIFACTS_BUCKET="partner-services-deployment-${TARGET_ACCOUNT_ID}"
S3_ARTIFACTS_PATH="code/${SERVICE_NAME}-${PARTNER}-${STAGE}"


echo "Printing Local scope variables";
echo "PARTNER :: $PARTNER"
echo "STAGE :: $STAGE"
echo "SERVICE_NAME :: $SERVICE_NAME"
echo "SERVICE_TYPE :: $SERVICE_TYPE"


echo "Validating the cfn templates `date` in `pwd`" ;
sam validate -t ./templates/formation.yml ;
echo "Starting SAM build `date` in `pwd`" ;

aws s3 cp public s3://html-demo-$TARGET_ACCOUNT_ID-${PARTNER}-${STAGE} --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers --recursive

sam deploy --template-file ./templates/formation.yml \
--stack-name html-example-${PARTNER}-${STAGE} \
--region ${TARGET_REGION} \
--capabilities CAPABILITY_IAM \
--no-fail-on-empty-changeset \
--parameter-overrides \
ParameterKey=Partner,ParameterValue=${PARTNER} \
ParameterKey=Stage,ParameterValue=${STAGE} \
ParameterKey=DeploymentMode,ParameterValue=${MODE}

if ! [ -z ${DISTRIBUTION+x} ]; then aws cloudfront create-invalidation --distribution-id $DISTRIBUTION --paths "/*" ; fi;
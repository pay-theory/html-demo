#!/usr/bin/env bash

PARTNER=$1
STAGE=$2
SERVICE_TYPE=$3
SERVICE_NAME=$4
TARGET_MODE=$5

S3_ARTIFACTS_BUCKET="partner-services-deployment-${TARGET_ACCOUNT_ID}"
S3_ARTIFACTS_PATH="code/${SERVICE_NAME}-${PARTNER}-${STAGE}"


echo "Printing Local scope variables";
echo "PARTNER :: $PARTNER"
echo "STAGE :: $STAGE"
echo "SERVICE_NAME :: $SERVICE_NAME"
echo "SERVICE_TYPE :: $SERVICE_TYPE"
echo "TARGET_MODE :: $TARGET_MODE"
echo "S3_ARTIFACTS_BUCKET :: $S3_ARTIFACTS_BUCKET"
echo "S3_ARTIFACTS_PATH :: $S3_ARTIFACTS_PATH"


echo "Validating the cfn templates $(date) in $(pwd)" ;
sam validate -t ./templates/formation.yml ;
echo "Starting SAM build $(date) in $(pwd)" ;

aws s3 cp public s3://html-demo-"${TARGET_ACCOUNT_ID}"-"${PARTNER}"-"${STAGE}" --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers --recursive

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

sam deploy --template-file ./templates/formation.yml \
--stack-name html-example-"${PARTNER}"-"${STAGE}" \
--region "${TARGET_REGION}" \
--capabilities CAPABILITY_IAM \
--no-fail-on-empty-changeset \
--parameter-overrides \
ParameterKey=Partner,ParameterValue="${PARTNER}" \
ParameterKey=Stage,ParameterValue="${STAGE}" \
ParameterKey=TargetMode,ParameterValue="${TARGET_MODE}" | tee "${SCRIPT_DIR}"/error_check_one.txt

if grep -i -q -E "error|failed|UPDATE_ROLLBACK_COMPLETE" "${SCRIPT_DIR}"/error_check_one.txt; then
    echo "Failed to update!"
    exit 1
else
    echo "No errors or failures found"
fi

if ! [ -z ${DISTRIBUTION+x} ]; then aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION" --paths "/*" ; fi;
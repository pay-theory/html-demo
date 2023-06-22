#!/usr/bin/env bash

PARTNER=$1
STAGE=$2
SERVICE_TYPE=$3
SERVICE_NAME=$4
TARGET_MODE=$5

S3_ARTIFACTS_BUCKET="partner-services-deployment-${PARTNER}-${TARGET_ACCOUNT_ID}-${TARGET_REGION}"
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
aws cloudformation validate-template --template-body file://templates/formation.yml ;

aws s3 cp public s3://html-demo-"${TARGET_ACCOUNT_ID}"-"${PARTNER}"-"${STAGE}" --recursive

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "Deploying certificates and hosted zone resources"
aws cloudformation deploy --template-file ./templates/distribution.yml \
--stack-name "${SERVICE_NAME}"-distribution-"${PARTNER}"-"${STAGE}" \
--region "us-east-1" \
--capabilities CAPABILITY_IAM \
--no-fail-on-empty-changeset \
--parameter-overrides \
ParameterKey=Partner,ParameterValue="${PARTNER}" \
ParameterKey=Stage,ParameterValue="${STAGE}" \
ParameterKey=TargetMode,ParameterValue="${TARGET_MODE}"

echo "Retrieving hosted zone" ;
HOSTED_ZONE=$(aws --region="us-east-1" ssm get-parameters --name "${SERVICE_NAME}-${PARTNER}-${STAGE}-hosted-zone" --output text --query "Parameters[0].Value")
echo "Retrieving certificate" ;
CERTIFICATE_ARN=$(aws --region="us-east-1" ssm get-parameters --name "${SERVICE_NAME}-${PARTNER}-${STAGE}-certificate-arn" --output text --query "Parameters[0].Value")

aws cloudformation deploy --template-file ./templates/formation.yml \
--stack-name html-example-"${PARTNER}"-"${STAGE}" \
--region "${TARGET_REGION}" \
--capabilities CAPABILITY_NAMED_IAM \
--no-fail-on-empty-changeset \
--parameter-overrides \
ParameterKey=Partner,ParameterValue="${PARTNER}" \
ParameterKey=Stage,ParameterValue="${STAGE}" \
ParameterKey=TargetMode,ParameterValue="${TARGET_MODE}" \
ParameterKey=HostedZone,ParameterValue="${HOSTED_ZONE}" \
ParameterKey=CertificateArn,ParameterValue="${CERTIFICATE_ARN}" | tee "${SCRIPT_DIR}"/error_check_one.txt

if grep -i -q -E "UPDATE_ROLLBACK_COMPLETE|UPDATE_ROLLBACK_FAILED|error|ValidationError|(Throttling)|failure" "${SCRIPT_DIR}"/error_check_one.txt; then
    echo "Failed to update!"
    exit 1
elif [ ! -f "${SCRIPT_DIR}"/error_check_one.txt  ]; then
    echo "Error check files are missing."
    exit 1
else
    echo "No errors or failures found"
fi

echo "Retrieving cloudwatch kms key" ;
KMS_KEY_ID=$(aws --region="${TARGET_REGION}" ssm get-parameters --name "pt-keys-cloudwatch-sym-key" --output text --query "Parameters[0].Value")
if [[ ${KMS_KEY_ID} != *"arn"* ]]
then
    echo "Failed to retrieve cloudwatch kms key!"
    exit 1
else
    echo "Cloudwatch kms key retrieved..."
fi

# Define the log groups
CODEBUILD_LOG_GROUP_NAME="/aws/codebuild/cb-${SERVICE_NAME}-${PARTNER}-${STAGE}"

# Check if the log group exists
GET_CODEBUILD_LOG_RESPONSE=$(aws --region="${TARGET_REGION}" logs describe-log-groups --log-group-name-prefix "${CODEBUILD_LOG_GROUP_NAME}" --query 'logGroups[?logGroupName==`'"${CODEBUILD_LOG_GROUP_NAME}"'`].logGroupName' --output text)

if [[ ${GET_CODEBUILD_LOG_RESPONSE} != *"/aws/"* ]]
then
    echo "Log group does not exist!"
else
    echo "Log group exists, associating kms key... "
    aws logs --region="${TARGET_REGION}" associate-kms-key --log-group-name "${CODEBUILD_LOG_GROUP_NAME}" --kms-key-id "${KMS_KEY_ID}"
fi
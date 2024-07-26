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



echo "Deploying certificates and hosted zone resources"
aws cloudformation deploy --template-file ./templates/distribution.yml \
--stack-name "${SERVICE_NAME}"-distribution-"${PARTNER}"-"${STAGE}" \
--region "us-east-1" \
--capabilities CAPABILITY_IAM \
--no-fail-on-empty-changeset \
--parameter-overrides \
Partner="${PARTNER}" \
Stage="${STAGE}" \
TargetMode="${TARGET_MODE}"

# Check the status of cloudformation stack set
STATUS=$(aws cloudformation describe-stacks --region "us-east-1" --stack-name "${SERVICE_NAME}"-distribution-"${PARTNER}"-"${STAGE}" --output text --query "Stacks[0].StackStatus")
if [ "$STATUS" = "CREATE_COMPLETE" ]; then
  echo "The cloudformation stack set has been created successfully"
elif [ "$STATUS" = "UPDATE_COMPLETE" ]; then
  echo "The cloudformation stack set has been updated successfully"
elif [ "$STATUS" = "UPDATE_IN_PROGRESS" ]; then
  echo "The cloudformation stack set is currently being updated"
else
  echo "The cloudformation stack failed to complete"
  exit 1
fi

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
Partner="${PARTNER}" \
Stage="${STAGE}" \
TargetMode="${TARGET_MODE}" \
HostedZone="${HOSTED_ZONE}" \
CertificateArn="${CERTIFICATE_ARN}"

# Check the status of cloudformation stack set
STATUS=$(aws cloudformation describe-stacks --stack-name html-example-"${PARTNER}"-"${STAGE}" --output text --query "Stacks[0].StackStatus")
if [ "$STATUS" = "CREATE_COMPLETE" ]; then
  echo "The cloudformation stack set has been created successfully"
elif [ "$STATUS" = "UPDATE_COMPLETE" ]; then
  echo "The cloudformation stack set has been updated successfully"
elif [ "$STATUS" = "UPDATE_IN_PROGRESS" ]; then
  echo "The cloudformation stack set is currently being updated"
else
  echo "The cloudformation stack failed to complete"
  exit 1
fi

echo "Retrieving cloudwatch kms key" ;
KMS_KEY_ID=$(aws --region="${TARGET_REGION}" ssm get-parameters --name pt-keys-"${PARTNER}"-cloudwatch-sym-key --output text --query "Parameters[0].Value")
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


##################### GIT Recreation of branch ############################

if [[ $TARGET_MODE = "standard" ]]
then
    MODE=""
else
    MODE=$TARGET_MODE
fi

# if we do not have the branch in remote create it
existed_in_remote=$(git ls-remote --heads origin "${PARTNER}""${MODE}"-"${STAGE}" 2>/dev/null)
if [[ -z ${existed_in_remote} ]]
then
    git fetch -p
    echo "Recreating branch ${PARTNER}${MODE}-${STAGE} from current branch"
    git checkout -b "${PARTNER}""${MODE}"-"${STAGE}"
    git push -u origin "${PARTNER}""${MODE}"-"${STAGE}"
#end if we do not have the branch in remote create it
fi

##########################################################################


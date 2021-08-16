#!/usr/bin/env bash

PARTNER=$1
STAGE=$2
SERVICE_NAME=$3
SERVICE_TYPE=$4
# prepare for deployment

S3_ARTIFACTS_BUCKET="partner-services-deployment-${TARGET_ACCOUNT_ID}"
S3_ARTIFACTS_PATH="code/${SERVICE_NAME}-${PARTNER}-${STAGE}"

# directory for service source code if applicable
# mkdir -p src/${SERVICE_NAME}/service
mkdir -p src/${SERVICE_NAME}
# directory for deployment package
mkdir -p build_dir/${SERVICE_NAME}

# copy in root python files
cp *.py src/${SERVICE_NAME}/.



echo "Printing Local scope variables";
echo "PARTNER :: $PARTNER"
echo "STAGE :: $STAGE"
echo "SERVICE_NAME :: $SERVICE_NAME"
echo "SERVICE_TYPE :: $SERVICE_TYPE"
echo "S3_ARTIFACTS_BUCKET :: $S3_ARTIFACTS_BUCKET"
echo "S3_ARTIFACTS_PATH :: $S3_ARTIFACTS_PATH"


echo "Validating the cfn templates `date` in `pwd`" ;
sam validate -t ./templates/formation.yml ;
echo "Starting SAM build `date` in `pwd`" ;

docker pull amazon/aws-sam-cli-build-image-python3.8

echo "SAM BUILD" ;
sam build --use-container --template-file ./templates/formation.yml --base-dir src/${SERVICE_NAME}/ -m ./public_requirements.txt --build-dir build_dir/${SERVICE_NAME} --skip-pull-image;
echo "SAM build completed" ;


echo "Pip install"
pip3 install -r ./model.requirements.txt -t build_dir/${SERVICE_NAME}/Lambda
echo "pip install completed"

#!/usr/bin/env bash

MODE=$1
PARTNER=$2
REPO=html-demo
aws cloudformation ${MODE}-stack \
--region 'us-east-1' \
--capabilities CAPABILITY_NAMED_IAM \
--stack-name pt-account-$REPO \
--template-body file://global.yml --parameters ParameterKey=Partner,ParameterValue=${PARTNER}
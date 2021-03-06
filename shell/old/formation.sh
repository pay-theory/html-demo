#!/usr/bin/env bash

PARTNER=$1
STAGE=$2
MODE=$3
aws cloudformation ${MODE}-stack \
--region 'us-east-1' \
--capabilities CAPABILITY_IAM \
--stack-name html-example-${PARTNER}-${STAGE} \
--template-body file://formation.yml \
--parameters ParameterKey=Partner,ParameterValue=${PARTNER} \
ParameterKey=Stage,ParameterValue=${STAGE}
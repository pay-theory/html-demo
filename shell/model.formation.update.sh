#!/usr/bin/env bash

ENV=""
API_KEY=""

aws cloudformation update-stack \
--region 'us-east-1' \
--stack-name html-example-${ENV} \
--template-body file://formation.yml \
--parameters ParameterKey=Env,ParameterValue=${ENV} \
    ParameterKey=ApiKey,ParameterValue=${API_KEY}
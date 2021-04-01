#!/usr/bin/env bash

ENV=""


aws cloudformation create-stack \
--region 'us-east-1' \
--stack-name secure-tags-lib-${ENV} \
--template-body file://formation.yml \
--parameters ParameterKey=Env,ParameterValue=${ENV}
#!/usr/bin/env bash

ENV=""

aws cloudformation update-stack \
--region 'us-east-1' \
--stack-name html-example-${ENV} \
--template-body file://formation.yml \
--parameters ParameterKey=Env,ParameterValue=${ENV}
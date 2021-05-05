#!/usr/bin/env bash

ENV=$1
INIT_CACHE_POLICY="a8098176-2a5f-4537-9943-00a6b95e43b4"
POST_INIT_CACHE_POLICY="f07eda0f-b830-4ed7-ba09-0bd5504ca2ff"
aws cloudformation create-stack \
--region 'us-east-1' \
--stack-name html-example-${ENV} \
--template-body file://formation.yml \
--parameters ParameterKey=Env,ParameterValue=${ENV} \
ParameterKey=CachePolicy,ParameterValue=${POST_INIT_CACHE_POLICY}
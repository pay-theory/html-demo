#!/usr/bin/env bash

ENV=$1
POST_INIT_CACHE_POLICY="f07eda0f-b830-4ed7-ba09-0bd5504ca2ff"
aws cloudformation update-stack \
--region 'us-east-1' \
--stack-name html-example-${ENV} \
--template-body file://formation.yml \
--parameters ParameterKey=Env,ParameterValue=${ENV} \
ParameterKey=CachePolicy,ParameterValue=${POST_INIT_CACHE_POLICY}


# aws cloudfront update-distribution --id E3JY6HJ99UZLWN --default-root-object index.html

#aws cloudfront create-invalidation --distribution-id E3JY6HJ99UZLWN --paths /*
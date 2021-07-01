#!/usr/bin/env bash

PARTNER=$1
STAGE=$2

export REACT_APP_PARTNER=$PARTNER
export REACT_APP_STAGE=$STAGE
export REACT_APP_ENVIRONMENT=$PARTNER-$STAGE
export SDK_URL=https://$PARTNER.sdk.$STAGE.com/index.js
bash shell/build_env.sh $PARTNER $STAGE
export ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
bash shell/deploy.sh
bash shell/formation.sh $PARTNER $STAGE update
aws cloudfront create-invalidation --distribution-id $DISTRIBUTION --paths "/*"
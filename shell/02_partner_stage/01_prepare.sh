#!/usr/bin/env bash

PARTNER=$1
STAGE=$2
SERVICE_NAME=$3
SERVICE_TYPE=$4

export PARTNER=$1
export STAGE=$2
export ENVIRONMENT=$1-$2
export SDK_URL="$PARTNER.sdk.$STAGE.com"

echo "Starting build $SDK_URL in `pwd`" ;


# prepare for deployment

# remove prior builds
rm -rf public/*

# directory for compiled source code if applicable
# mkdir -p src/${SERVICE_NAME}/service
mkdir -p public

# copy in root html file
sed 's#SDK_URL#'$SDK_URL'#g' templates/html/index.html > public/index.html
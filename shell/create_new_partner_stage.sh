#!/usr/bin/env bash

PARTNER=$1
STAGE=$2

git push origin main:$PARTNER-$STAGE

sh shell/formation.sh $PARTNER $STAGE create
sh shell/build_env.sh $PARTNER $STAGE
sh shell/deploy.sh
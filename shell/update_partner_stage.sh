#!/usr/bin/env bash

PARTNER=$1
STAGE=$2

git checkout -b $PARTNER-$STAGE
git push --set-upstream origin $PARTNER-$STAGE

sh shell/formation.sh $PARTNER $STAGE update

sh shell/deploy.sh $PARTNER $STAGE
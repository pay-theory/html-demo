#!/usr/bin/env bash

PARTNER=$1
STAGE=$2

sh shell/formation.sh $PARTNER $STAGE update

sh shell/deploy.sh $PARTNER $STAGE
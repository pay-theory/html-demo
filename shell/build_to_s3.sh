PARTNER=$1
STAGE=$2

npm install -g npm@latest
export REACT_APP_PARTNER=$PARTNER
export REACT_APP_STAGE=$STAGE
export REACT_APP_ENVIRONMENT=$PARTNER-$STAGE
export SDK_URL=https://$PARTNER.sdk.$STAGE.com/index.js

sh shell/build_env.sh $PARTNER $STAGE
sh shell/deploy.sh

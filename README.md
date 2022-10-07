# html-demo

A demonstration page of Pay Theory JavaScript SDK

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/814cedb86cdb4ead94e04b02f0efc60f)](https://www.codacy.com/gh/pay-theory/html-demo/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=pay-theory/html-demo&amp;utm_campaign=Badge_Grade)

## Initial Deployment

Replace values of these variables and export local environment variables in your cli

```shell
export TARGET_REGION=AWS_REGION ;
export TARGET_ACCOUNT_ID=ACCOUNT_NUMBER;
export PARTNER=PARTNER_NAME
export GITHUB_ACCESS_TOKEN=GITHUB_ACCESS_TOKEN
export STAGE=STAGE
export SERVICE_TYPE=SERVICE_TYPE
export SERVICE_NAME=SERVICE_NAME
export TARGET_MODE=standard
```

Run bash shell commands in buildspec.yml

```shell
bash shell/01_prepare.sh $PARTNER $STAGE $SERVICE_TYPE $SERVICE_NAME $GITHUB_ACCESS_TOKEN $TARGET_MODE
bash shell/02_deploy.sh $PARTNER $STAGE $SERVICE_TYPE $SERVICE_NAME $TARGET_MODE   
```
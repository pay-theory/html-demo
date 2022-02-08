#!/usr/bin/env bash

export PARTNER=$1
export STAGE=$2

# if there is a .git directory we are in partner-factory
if [ -d ".git" ]
then

# if we do not have the branch in remote create it
existed_in_remote=$(git ls-remote --heads origin ${PARTNER}${MODE}-${STAGE} 2>/dev/null)
if [[ -z ${existed_in_remote} ]]
then
    echo "Branch ${PARTNER}${MODE}-${STAGE} not existed in remote, Creating now..."
    git checkout -b ${PARTNER}${MODE}-${STAGE}
    git push -u origin ${PARTNER}${MODE}-${STAGE}
else
    echo "Branch ${PARTNER}${MODE}-${STAGE} existed in remote, Taking backup now..."
    BASE_BRANCH=$(git symbolic-ref --short HEAD)
    echo "Creating backup branch with name" ${PARTNER}${MODE}-${STAGE}-date "+%Y%m%d-%H%M%S"
    git checkout -b ${PARTNER}${MODE}-${STAGE}-date "+%Y%m%d-%H%M%S"
    git push -u origin ${PARTNER}${MODE}-${STAGE}
    echo "Deleting branch ${PARTNER}${MODE}-${STAGE}"
    git push origin --delete ${PARTNER}${MODE}-${STAGE} &>/dev/null
    git branch -D ${PARTNER}${MODE}-${STAGE} &>/dev/null
    echo "Recreating branch ${PARTNER}${MODE}-${STAGE} from base branch ${BASE_BRANCH}"
    git checkout -b ${PARTNER}${MODE}-${STAGE} ${BASE_BRANCH}
    git push -u origin ${PARTNER}${MODE}-${STAGE}
#end if we do not have the branch in remote create it
fi

#end if there is a .git directory we are in partner-factory
fi

export ENVIRONMENT=$1-$2
export SDK_URL="https://$PARTNER.sdk.$STAGE.com/index.js"

echo "Starting build $SDK_URL in `pwd`" ;

# prepare for deployment
# remove prior builds
rm -rf public/$STAGE

# directory for compiled source code
mkdir -p public/$STAGE/$PARTNER

echo $PARTNER-$STAGE Credit Card Build started on `date`

# copy in html templates
sed 's#TEMPLATE_URL#'$SDK_URL'#g' templates/html/pay-theory-credit-card.html | sed 's/TEMPLATE_ENVIRONMENT/'$ENVIRONMENT'/g' > public/$STAGE/$PARTNER/pay-theory-credit-card.html
sed 's#TEMPLATE_URL#'$SDK_URL'#g' templates/html/pay-theory-credit-card-number.html | sed 's/TEMPLATE_ENVIRONMENT/'$ENVIRONMENT'/g' > public/$STAGE/$PARTNER/pay-theory-credit-card-number.html
sed 's#TEMPLATE_URL#'$SDK_URL'#g' templates/html/pay-theory-ach.html | sed 's/TEMPLATE_ENVIRONMENT/'$ENVIRONMENT'/g' > public/$STAGE/$PARTNER/pay-theory-ach.html

# copy in root html file
cp index.html public/$STAGE/$PARTNER/.
export PARTNER=$1
export STAGE=$2
export ENVIRONMENT=$1-$2
export SDK_URL="https://$PARTNER.sdk.$STAGE.com/index.js"
rm -rf public/$STAGE
mkdir public/$STAGE
mkdir public/$STAGE/$PARTNER
echo $PARTNER-$STAGE Credit Card Build started on `date`
sed 's#TEMPLATE_URL#'$SDK_URL'#g' templates/pay-theory-credit-card.html | sed 's/TEMPLATE_ENVIRONMENT/'$ENVIRONMENT'/g' > public/$STAGE/$PARTNER/pay-theory-credit-card.html
sed 's#TEMPLATE_URL#'$SDK_URL'#g' templates/pay-theory-credit-card-number.html | sed 's/TEMPLATE_ENVIRONMENT/'$ENVIRONMENT'/g' > public/$STAGE/$PARTNER/pay-theory-credit-card-number.html
sed 's#TEMPLATE_URL#'$SDK_URL'#g' templates/pay-theory-ach.html | sed 's/TEMPLATE_ENVIRONMENT/'$ENVIRONMENT'/g' > public/$STAGE/$PARTNER/pay-theory-ach.html
cp index.html public/$STAGE/$PARTNER/.
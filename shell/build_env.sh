export ENVIRONMENT=$1
mkdir public/html/$ENVIRONMENT
echo $ENVIRONMENT Credit Card Build started on `date`
sed 's#TEMPLATE_URL#'$SDK_URL'#g' templates/pay-theory-credit-card.html | sed 's/TEMPLATE_ENVIRONMENT/'$ENVIRONMENT'/g' > public/html/$ENVIRONMENT/pay-theory-credit-card.html
sed 's#TEMPLATE_URL#'$SDK_URL'#g' templates/pay-theory-credit-card-number.html | sed 's/TEMPLATE_ENVIRONMENT/'$ENVIRONMENT'/g' > public/html/$ENVIRONMENT/pay-theory-credit-card-number.html
sed 's#TEMPLATE_URL#'$SDK_URL'#g' templates/pay-theory-ach.html | sed 's/TEMPLATE_ENVIRONMENT/'$ENVIRONMENT'/g' > public/html/$ENVIRONMENT/pay-theory-ach.html
cp index.html public/html/$ENVIRONMENT/.
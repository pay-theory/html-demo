export PARTNER=$1
export STAGE=$2
export ENVIRONMENT=$1-$2
export SDK_URL="https://${PARTNER}${MODE}.sdk.${STAGE}.com/index.js"

echo "Starting build $SDK_URL in $(pwd)" ;

# prepare for deployment
# remove prior builds
rm -rf public/"$STAGE"

# directory for compiled source code
mkdir -p public/"$STAGE"/"$PARTNER"

echo "$PARTNER"-"$STAGE" Credit Card Build started on "$(date)"

# copy in html templates
sed 's#TEMPLATE_URL#'"$SDK_URL"'#g' templates/html/pay-theory-credit-card.html | sed 's/TEMPLATE_ENVIRONMENT/'"$ENVIRONMENT"'/g' > public/"$STAGE"/"$PARTNER"/pay-theory-credit-card.html
sed 's#TEMPLATE_URL#'"$SDK_URL"'#g' templates/html/pay-theory-credit-card-number.html | sed 's/TEMPLATE_ENVIRONMENT/'"$ENVIRONMENT"'/g' > public/"$STAGE"/"$PARTNER"/pay-theory-credit-card-number.html
sed 's#TEMPLATE_URL#'"$SDK_URL"'#g' templates/html/pay-theory-ach.html | sed 's/TEMPLATE_ENVIRONMENT/'"$ENVIRONMENT"'/g' > public/"$STAGE"/"$PARTNER"/pay-theory-ach.html
sed 's#TEMPLATE_URL#'"$SDK_URL"'#g' templates/html/pay-theory-barcode.html | sed 's/TEMPLATE_ENVIRONMENT/'"$ENVIRONMENT"'/g' > public/"$STAGE"/"$PARTNER"/pay-theory-barcode.html
sed 's#TEMPLATE_URL#'"$SDK_URL"'#g' templates/html/pay-theory-qrcode.html | sed 's/TEMPLATE_ENVIRONMENT/'"$ENVIRONMENT"'/g' > public/"$STAGE"/"$PARTNER"/pay-theory-qrcode.html
sed 's#TEMPLATE_URL#'"$SDK_URL"'#g' templates/html/pay-theory-button.html | sed 's/TEMPLATE_ENVIRONMENT/'"$ENVIRONMENT"'/g' > public/"$STAGE"/"$PARTNER"/pay-theory-button.html

# copy in root html file
cp index.html public/"$STAGE"/"$PARTNER"/.
export REACT_APP_ENVIRONMENT=$1
npm run build
aws s3 cp build s3://secure-tags-lib-$1 --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers --recursive --cache-control max-age=3
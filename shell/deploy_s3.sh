zip -g my-deployment-package.zip *.py
aws s3api put-object --bucket tags-secure-socket-$1 --key my-deployment-package.zip --body my-deployment-package.zip
#!/bin/bash

set -e -u

# Sphinx Build
sudo pip install --upgrade pip
sudo pip install sphinx
cd $1
make html

if [[ "$TRAVIS_PULL_REQUEST" == "false" ]]; then
    # S3 Deploy
    sudo pip install awscli
    echo "Deploying to bucket: $AWS_BUCKET"
    aws s3 sync $2 s3://$AWS_BUCKET/ --acl public-read
fi
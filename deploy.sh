#!/bin/bash

set -e -u

# Sphinx Build
sudo pip install --upgrade pip
sudo pip install -r travis-sphinx-deploy/requirements.txt
cd $1
make html

#S3 Deploy
if [[ "$TRAVIS_PULL_REQUEST" == "false" ]]; then

    sudo pip install awscli
    echo "Deploying to bucket: $AWS_BUCKET"

    if [[ "$TRAVIS_BRANCH" == "release/"* ]]; then

        echo "Syncing release..."
        version=$(awk -F '/' '{print $2}' <<< $TRAVIS_BRANCH)
        aws s3 sync $2 s3://$AWS_BUCKET/v$version --acl public-read
    fi

    if [[ "$TRAVIS_BRANCH" == "master" ]]; then

        echo "Syncing latest..."
        aws s3 sync $2 s3://$AWS_BUCKET/ --acl public-read  
    fi
fi
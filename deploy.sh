#!/bin/bash

set -e -u

# Sphinx Build
sudo pip install --upgrade pip
sudo pip install -r requirements.txt
cd $1
make html

#S3 Deploy
if [[ "$TRAVIS_PULL_REQUEST" == "false" ]]; then

    sudo pip install awscli

    acl="public-read"
    if [[ "$AWS_ACL" ]]; then
        acl=$AWS_ACL
    fi

    echo "Deploying to bucket: $AWS_BUCKET"
    echo "ACL: $acl"

    if [[ "$TRAVIS_BRANCH" == "release/"* ]]; then

        echo "Syncing release..."
        version=$(awk -F '/' '{print $2}' <<< $TRAVIS_BRANCH)
        aws s3 sync $2 s3://$AWS_BUCKET/v$version --acl $acl
    fi

    if [[ "$TRAVIS_BRANCH" == "master" ]]; then

        echo "Syncing latest..."
        aws s3 sync $2 s3://$AWS_BUCKET/ --acl $acl 
    fi
fi
#!/bin/bash

set -e -u

# Sphinx Build
sudo pip install --upgrade pip
sudo pip install sphinx
make html

# S3 Deploy
sudo pip install awscli
echo "Deploying to bucket: $AWS_BUCKET"
aws s3 sync _build/html s3://$AWS_BUCKET/
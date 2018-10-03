#!/bin/bash

set -e -u

# Sphinx Build
#sudo pip install --upgrade pip
sudo pip install --upgrade pip==9.0.3
sudo pip install -r requirements.txt
cd $1
make html

# If this Travis job is not a pull request, 
# assume it is a merge and deploy to S3
if [[ "$TRAVIS_PULL_REQUEST" == "false" ]]; then

    sudo pip install awscli

    AWS_ACL="${AWS_ACL-public-read}"

    echo "Deploying to bucket: $AWS_BUCKET"
    echo "ACL: $AWS_ACL"

    if [[ "$TRAVIS_BRANCH" == "release/"* ]]; then

        echo "Syncing release..."
        version=$(awk -F '/' '{print $2}' <<< $TRAVIS_BRANCH)
        aws s3 sync $2 s3://$AWS_BUCKET/v$version --acl $AWS_ACL --cache-control max-age=3600 --delete
    fi

    if [[ "$TRAVIS_BRANCH" == "master" ]]; then

      # echo -n "Moving versioned topics to temporary directory..."
      # aws s3 mv s3://$AWS_BUCKET/ tmp/ --acl private --include "/v[3-9].[0-9]/*" --recursive 
      # echo "done"
    
      echo -n "Syncing latest..."
      aws s3 sync $2 s3://$AWS_BUCKET/ --acl $AWS_ACL --cache-control max-age=3600 --delete
      echo "done"

      # echo -n "Moving versioned topics back to public bucket..."
      # aws s3 mv tmp/ s3://$AWS_BUCKET/ --acl $AWS_ACL --cache-control max-age=3600 --include "/v[3-9].[0-9]/*" --recursive
      # echo "done"

    fi
else
  echo "As this build was for Pull Request $TRAVIS_PULL_REQUEST, there was no deployment to AWS."
fi

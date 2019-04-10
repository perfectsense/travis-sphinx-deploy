#!/bin/bash
# In a test environment, run this script as follows:
# 1) Change to the repo containing the documentation (cd ~/docs)
# 2) Place this script inside the repo directory
# 3) Run ./deploy.sh . _build/html
#
# Uncomment the following two lines for testing:
# TRAVIS_PULL_REQUEST="false"
# AWS_BUCKET=mldocs.brightspot.com
#
# Scenario 1: deploying a previous release. Uncomment the following:
# TRAVIS_BRANCH=release/3.2
# Scenario 2: deploying the current release. Uncomment the following:
# TRAVIS_BRANCH=master
#
set -e -u

# Sphinx Build
sudo pip install --upgrade pip==9.0.3
sudo pip install -r requirements.txt
echo "Finished the pip install from requirements"
sudo pip install -i https://test.pypi.org/simple/ pygments-lexer-overrides==0.0.4
echo "Finished the pip install from test.pypi"
echo "Finding marksafe"
sudo find / -iname "marksafe*" 2>/dev/null
echo "Finding pygments"
sudo find / -iname "pygments*" 2>/dev/null
# sudo python -m pygments-lexer-overrides
sudo python -m pygments-lexer-overrides
echo "Finished run of pygments-lexer-overrides"
cd $1
make html

# If this Travis job is not a pull request, 
# assume it is a merge and deploy to S3

# public-read is default when AWS_ACL isn't set
AWS_ACL="${AWS_ACL:-public-read}"

if [[ "$TRAVIS_PULL_REQUEST" == "false" ]]; then

    sudo pip install awscli

    echo "Deploying to bucket: $AWS_BUCKET"

    if [[ "$TRAVIS_BRANCH" == "release/"* ]]; then

        version=$(awk -F '/' '{print $2}' <<< $TRAVIS_BRANCH)
        echo "Synching for release $version..."
        aws s3 sync $2 s3://$AWS_BUCKET/v$version --acl $AWS_ACL --cache-control max-age=3600 --delete
        echo "Done synching release $version"
    fi

    if [[ "$TRAVIS_BRANCH" == "master" ]]; then
    
      echo "Synching master..."
      aws s3 sync $2 s3://$AWS_BUCKET/ --acl $AWS_ACL --include "*" --exclude "v?.?/*"  --delete
      echo "Done syching master"

    fi
else
   echo "As this build was for Pull Request $TRAVIS_PULL_REQUEST, there was no deployment to AWS."
fi

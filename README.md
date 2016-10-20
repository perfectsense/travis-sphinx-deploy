# Travis Sphinx Deploy

##Setup

**S3**

1. Create an S3 Bucket (save your credentials for Travis!)

**Travis**

This script requires that your build has `sudo: required` in your .travis.yml due
to `sudo` usage.

1. Add `sudo: required` to your .travis.yml (sudo is required to install sphinx etc.)
2. Set Travis environment variables: 
    * `AWS_ACCESS_KEY_ID` (with your aws access key)
    * `AWS_SECRET_ACCESS_KEY` (with your aws secret key)
    * `AWS_BUCKET` (with your bucket name)

**Setup Redirect**

S3 does not support the index of your static site being inside of a subdirectory, to accomplish this, you can upload
an empty index.html file into the root of your bucket, and setup a redirect to your index.html inside of your folder.

![image](https://cloud.githubusercontent.com/assets/1299507/19402314/84e1e452-922e-11e6-89a3-5c3579503a10.png)

## Script

Performs the following actions:

Updates pip
Installs sphinx
Runs Sphinx
Deploys Sphinx site to S3
# Travis Sphinx Deploy

This script expects to find a requirements.txt file listing your pip dependencies. You can create this file using the following command:

```
    pip freeze > requirements.txt
```

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
3. Add script invocation to `after_script` like so: 

    ```
        after_script: git clone https://github.com/perfectsense/travis-sphinx-deploy.git && travis-sphinx-deploy/deploy.sh brightspot/developers-guide brightspot/developers-guide/_build/html
    ```

    Example assumes Makefile is in `brightspot/developers-guide` and resulting build output will be in `brightspot/developers-guide_build/html` 

**Setup Redirect**

S3 does not support the index of your static site being inside of a subdirectory, to accomplish this, you can upload
an empty index.html file into the root of your bucket, and setup a redirect to your index.html inside of your folder.

![image](https://cloud.githubusercontent.com/assets/1299507/19402314/84e1e452-922e-11e6-89a3-5c3579503a10.png)

## Script

Performs the following actions:

* Updates pip
* Installs sphinx
* Runs Sphinx
* Deploys Sphinx site to S3 (directory changes for release branches)
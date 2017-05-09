#!/bin/sh

make clean
make html

DEFAULT_PROFILE="default"
RESCALE_PROFILE="rescale"
S3_BUCKET_NAME="rescale-japan/cli"
SRC_DIR=_build/

export AWS_DEFAULT_PROFILE=${RESCALE_PROFILE}
aws configure list

aws s3 sync ${SRC_DIR} s3://${S3_BUCKET_NAME}/  --acl public-read

export AWS_DEFAULT_PROFILE=${DEFAULT_PROFILE}
aws configure list


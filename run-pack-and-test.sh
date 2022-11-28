#!/bin/sh
ENVIRONMENT_FILE=$1

# exit when any command fails
set -e

source /root/.bashrc 

# create an dpack environment
mamba env create -f $ENVIRONMENT_FILE
conda pack -n $ENVIRONMENT_NAME --ignore-missing-files --output $HOME/$ENVIRONMENT_NAME.tar.gz

# unpack 
cp $HOME/$ENVIRONMENT_NAME.tar.gz /tmp/$ENVIRONMENT_NAME.tar.gz
mkdir /tmp/$ENVIRONMENT_NAME
tar -xf /tmp/$ENVIRONMENT_NAME.tar.gz -C /tmp/$ENVIRONMENT_NAME
source /tmp/$ENVIRONMENT_NAME/bin/activate
/tmp/$ENVIRONMENT_NAME/bin/conda-unpack

# run tests
if [[ -f "/tmp/run-test.sh" ]]; then
    bash /tmp/run-test.sh
fi

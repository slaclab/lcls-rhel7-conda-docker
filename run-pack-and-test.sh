#!/bin/sh
ENVIRONMENT_FILE=$1

# exit when any command fails
set -e

umask 0022

export CONDA_PKGS_DIRS=/tmp/pkgs
export MAMBA_ROOT_PREFIX=/tmp/mamba-root

# create an dpack environment
mamba env create -y -f "$ENVIRONMENT_FILE" --prefix /tmp/$ENVIRONMENT_NAME
conda pack --prefix /tmp/$ENVIRONMENT_NAME --ignore-missing-files --output /tmp/$ENVIRONMENT_NAME.tar.gz

# unpack
mkdir /tmp/test_env
tar -xf /tmp/$ENVIRONMENT_NAME.tar.gz -C /tmp/test_env
source /tmp/test_env/bin/activate
/tmp/test_env/bin/conda-unpack

# run tests
if [[ -f "/tmp/run-test.sh" ]]; then
    bash /tmp/run-test.sh
fi

rm -rf /tmp/$ENVIRONMENT_NAME
rm -rf /tmp/test_env
mv "/tmp/$ENVIRONMENT_NAME.tar.gz" /output/

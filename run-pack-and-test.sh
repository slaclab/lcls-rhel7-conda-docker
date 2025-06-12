#!/bin/bash

# Main script for creating, testing, and packing up a conda environment for use on the SLAC network

set -e

umask 0022

mkdir -p /workspace
cd /workspace

# Retrieve the yaml file to create the conda environment from
ENVIRONMENT_NAME="$1"
ENVIRONMENT_FILE="${ENVIRONMENT_NAME}.yml"
ENV_PATH="/workspace/${ENVIRONMENT_NAME}"
GITHUB_REPO_URL="https://raw.githubusercontent.com/slaclab/lcls-python3-envs/main"
curl -L "${GITHUB_REPO_URL}/${ENVIRONMENT_NAME}.yml" -o "$ENVIRONMENT_FILE"

export CONDA_PKGS_DIRS="/pkgs"
export MAMBA_ROOT_PREFIX="/mamba-root"

# create and pack environment
mamba env create -y -f "$ENVIRONMENT_FILE" --prefix "$ENV_PATH"

# Any commands that should be taken prior to packing up the environment for use.
# This includes disabling binaries for which we want to use the operating system's version rather than conda's version,
# and disabling activate scripts that we don't want modifying our environment.
curl -L "${GITHUB_REPO_URL}/scripts/pre_pack.sh" -o pre_pack.sh
chmod +x pre_pack.sh
CONDA_PREFIX="$ENV_PATH" bash pre_pack.sh

conda pack --prefix "$ENV_PATH" --ignore-missing-files --output "${ENVIRONMENT_NAME}.tar.gz"

# unpack
mkdir test_env
tar -xf "${ENVIRONMENT_NAME}.tar.gz" -C "test_env"
source test_env/bin/activate
test_env/bin/conda-unpack

# run tests
curl -L "${GITHUB_REPO_URL}/scripts/run_${ENVIRONMENT_NAME}_tests.sh" -o run_tests.sh
chmod +x run_tests.sh
bash run_tests.sh

rm -rf "$ENVIRONMENT_NAME"
rm -rf "test_env"
chmod a+r "${ENVIRONMENT_NAME}.tar.gz"
mv "${ENVIRONMENT_NAME}.tar.gz" /output/

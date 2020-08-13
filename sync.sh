#!/bin/bash

set -euo pipefail

#GIT_SYNC_DIR
#GIT_SYNC_REPO
GIT_SYNC_PULL_OPTS=${GIT_SYNC_PULL_OPTS:--f}
GIT_SYNC_SLEEP=${GIT_SYNC_SLEEP:-1}

function check_req_var() {
    if [ ! -v ${1} ]; then
        error_req_var ${1}
    fi
}

function error_req_var() {
    echo "Environment variable '${1}' required but not set"
    exit 1
}

# check for required variables
check_req_var GIT_SYNC_DIR
check_req_var GIT_SYNC_REPO

# create destination dir if it does not exist
if [ ! -d "${GIT_SYNC_DIR}" ]; then
    mkdir -p "${GIT_SYNC_DIR}"
fi

# check if git directory already exists, if not, clone repo
if [ ! -d "${GIT_SYNC_DIR}/.git" ]; then
    git clone "${GIT_SYNC_REPO}" "${GIT_SYNC_DIR}"
fi

while true; do
    OUT=$(git -C "${GIT_SYNC_DIR}" pull "${GIT_SYNC_PULL_OPTS}")
    echo $(date -Iseconds) ${OUT}
    sleep "${GIT_SYNC_SLEEP}"
done

#!/bin/bash

set -euo pipefail

#GIT_SYNC_DIR
#GIT_SYNC_REPO
GIT_SYNC_PULL_OPTS=${GIT_SYNC_PULL_OPTS:--f}
GIT_SYNC_SLEEP=${GIT_SYNC_SLEEP:-1}
GIT_SYNC_NOTEMPTY=${GIT_SYNC_NOTEMPTY:-false}
GIT_SYNC_NOTEMPTY_OPTS=${GIT_SYNC_NOTEMPTY_OPTS:---mixed}
GIT_SYNC_BRANCH=${GIT_SYNC_BRANCH:-master}

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
    if [ ${GIT_SYNC_NOTEMPTY} = false ]; then
        git clone -b "${GIT_SYNC_BRANCH}" "${GIT_SYNC_REPO}" "${GIT_SYNC_DIR}"
    else
        git -C "${GIT_SYNC_DIR}" init
        git -C "${GIT_SYNC_DIR}" remote add origin "${GIT_SYNC_REPO}"
        git -C "${GIT_SYNC_DIR}" fetch
        git -C "${GIT_SYNC_DIR}" reset "${GIT_SYNC_NOTEMPTY_OPTS}" "origin/${GIT_SYNC_BRANCH}"
        git -C "${GIT_SYNC_DIR}" branch -u "origin/${GIT_SYNC_BRANCH}" "${GIT_SYNC_BRANCH}"

    fi
fi

while true; do
    OUT=$(git -C "${GIT_SYNC_DIR}" pull "${GIT_SYNC_PULL_OPTS}")
    echo $(date -Iseconds) ${OUT}
    sleep "${GIT_SYNC_SLEEP}"
done

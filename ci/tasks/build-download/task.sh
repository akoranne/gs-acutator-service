#!/bin/bash

set -e # fail fast
# set -x # print commands

export ROOT_FOLDER="$( pwd )"
export REPO_RESOURCE="service-repo"
export KEYVAL_RESOURCE=keyval
export KEYVALOUTPUT_RESOURCE=keyvalout
export BUILD_OUTPUT="${ROOT_FOLDER}/build-output"

echo "Root folder is [${ROOT_FOLDER}]"
echo "Repo resource folder is [${REPO_RESOURCE}]"
echo "KeyVal resource folder is [${KEYVAL_RESOURCE}]"

# import common functions
source "${ROOT_FOLDER}/${REPO_RESOURCE}/ci/tasks/resource-utils.sh"

# export passed properties to env
exportKeyValProperties

echo ""
echo " Downloading build"
echo " ...Build Id:  ${PASSED_build_id}"
echo " ...Build Url: ${PASSED_build_name}"
echo ""

# cd to the output folder
cd ${BUILD_OUTPUT}

export jf_instance="${JFROG_SERVER:-rt-server-1}"
export jf_user="${JFROG_USER:-admin}"
export jf_passwd="${JFROG_PASSWORD:-password}"
export jf_url="${JFROG_URL:-http://artifactory:8081/artifactory}"

echo "Artifactory endpoint info - "
echo ".... ${jf_instance} "
echo ".... ${jf_url}"
echo ".... ${jf_user}"

jfrog rt config "${jf_instance}" \
    --user="${jf_user}" --password="${jf_passwd}" \
    --url="${jf_url}"

# show
jfrog rt show

# copy all files from current location
jfrog rt dl "${PASSED_jfrog_path}" ${BUILD_OUTPUT}/ \
  --flat=true \
  --build-name="${PASSED_build_name}" \
  --build-number="${PASSED_build_id}"
#  --dry-run

pwd
ls -l ${BUILD_OUTPUT}

echo ""
echo " Build downloaded!!!"
echo ""

# write passed properties out
passKeyValProperties

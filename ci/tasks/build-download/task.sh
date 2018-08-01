#!/bin/bash

set -e # fail fast
# set -x # print commands

export ROOT_FOLDER="$( pwd )"
export REPO_RESOURCE="service-repo"
export KEYVAL_RESOURCE=keyval
export KEYVALOUTPUT_RESOURCE=keyvalout
export BUILD_OUTPUT="${ROOT_FOLDER}/build-output"

propsDir="${ROOT_FOLDER}/${KEYVALOUTPUT_RESOURCE}"
propsFile="${propsDir}/keyval.properties"

echo "Root folder is [${ROOT_FOLDER}]"
echo "Repo resource folder is [${REPO_RESOURCE}]"
echo "KeyVal resource folder is [${KEYVAL_RESOURCE}]"

# import common functions
source "${ROOT_FOLDER}/${REPO_RESOURCE}/ci/tasks/resource-utils.sh"

# export passed properties to env
exportKeyValProperties

echo ""
echo " Downloading build"
echo " ...Build Id:  ${build_number}"
echo " ...Build Url: ${build_name}"
echo ""

# cd to the output folder
cd ${BUILD_OUTPUT}

echo "Artifactory endpoint info - "
echo "  ${JFROG_SERVER} "
echo "  ${JFROG_URL}"
echo "  ${JFROG_LOCATION}"
echo "  ${jfrog_path}"

jfrog rt config "${JFROG_SERVER}" \
    --user="${JFROG_USER}" --password="${JFROG_PASSWORD}" \
    --url="${JFROG_URL}"

# show
jfrog rt show

# copy all files from current location
jfrog rt dl "${jfrog_path}" ${BUILD_OUTPUT}/ \
  --flat=false \
  --build-name="${build_name}" \
  --build-number="${build_number}"
#  --dry-run

ls -l ${BUILD_OUTPUT}

echo ""
echo " Build downloaded!!!"
echo ""

# write passed properties out
passKeyValProperties

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
echo "Build output folder is [${BUILD_OUTPUT}]"
echo "Repo resource folder is [${REPO_RESOURCE}]"
echo "KeyVal resource folder is [${KEYVAL_RESOURCE}]"

# import common functions
source "${ROOT_FOLDER}/${REPO_RESOURCE}/ci/tasks/resource-utils.sh"

# export passed properties to env
exportKeyValProperties

echo ""
echo " .. Running smoke-test for ${TARGET_ENV}"
echo ""

cd $REPO_RESOURCE

# execute newman tests

if [[ -z "${TARGET_ENV}" ]]; then

  export SMOKE_TEST_FILE="src/main/resources/postman/smoke-test.collection"

  if [[ "${TARGET_ENV}" == "development" ]]; then
  		echo ""
      export SMOKE_TEST_FILE="src/main/resources/postman/smoke-test.collection.dev"
  fi;
  newman run "${SMOKE_TEST_FILE}" | tee ../test-output/smoke_test_results.out
else

echo ""
echo " .. output files "
ls -l ../test-output

echo ""
echo " Smoke Test completed!!!"
echo ""

# write passed properties out
passKeyValProperties

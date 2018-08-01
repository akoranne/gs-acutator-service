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
echo " .. Running build"
echo ""

cd $REPO_RESOURCE

# gradle build
export GRADLE_OPTS="-Dorg.gradle.native=false"
./gradlew clean test assemble

# create target folder
# mkdir -f ../build-output

# move all manifests file to target
cp manifest.yml  ${BUILD_OUTPUT}

cp build/libs/*.jar ${BUILD_OUTPUT}


# change dir to the libs folder
cd build/libs

# get the file name from the archive
export PASSED_vers=$(ls -1 *.jar);
export PASSED_vers=${PASSED_vers%-*};
# export vers=${vers##*-};
echo " .. current version - ${PASSED_vers} ";

# go back
cd ../../

# copy the reports of the tests to the output folder
mkdir -p ${BUILD_OUTPUT}/reports
cp -rfv build/reports  ${BUILD_OUTPUT}/reports

# generate pdf documents from markdown and asciidocs
echo ""
echo " .. moving output files to Artifactory"
markdown-pdf *.md
mv *.pdf ${BUILD_OUTPUT}

echo ""
echo " .. output files "
ls -l ${BUILD_OUTPUT}

echo " .. TODO - need artifactory endpoints "

# metadata variables
PASSED_build_number="${PASSED_build_id}"
PASSED_build_name="${PASSED_atc_external_url}/teams/${PASSED_build_team_name}/pipelines/${PASSED_build_pipeline_name}"

# cd to the output folder
cd ${BUILD_OUTPUT}

echo "Artifactory endpoint info - "
echo "  ${JFROG_SERVER} "
echo "  ${JFROG_URL}"
echo "  ${JFROG_LOCATION}"
export PASSED_jfrog_path="${JFROG_LOCATION}/${PASSED_group}.${PASSED_vers}/"
echo "  ${PASSED_jfrog_path}"

jfrog rt config "${JFROG_SERVER}" \
    --user="${JFROG_USER}" --password="${JFROG_PASSWORD}" \
    --url="${JFROG_URL}"

# show
jfrog rt show

# copy all files from current location
jfrog rt u "*" "${PASSED_jfrog_path}" \
  --flat=false \
  --build-name="${PASSED_build_name}" \
  --build-number="${PASSED_build_number}"
#  --dry-run

# jfrog rt d "../build-output/*" libs-release-local/zipFiles/

echo ""
echo " Build Id:  ${PASSED_build_number}"
echo " Build Url: ${PASSED_build_name}"
echo " Build completed!!!"
echo ""

# write passed properties out
passKeyValProperties

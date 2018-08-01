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
export vers=$(ls -1 *.jar);
export vers=${vers%-*};
# export vers=${vers##*-};
echo " .. current version - ${vers} ";

# go back
cd ../../

# copy the reports of the tests to the output folder
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

# TODO: CTS
# move the files from 'test-output' to Artifactory
#
#

# metadata variables
group=${group}
build_number="${build_id}"
build_name="${atc_external_url}/teams/${build_team_name}/pipelines/${build_pipeline_name}"

# cd to the output folder
cd ${BUILD_OUTPUT}


echo "Artifactory info .."
echo "  ${JFROG_SERVER} "
echo "  ${JFROG_URL}"
echo "  ${JFROG_LOCATION}"

jfrog rt config "${JFROG_SERVER}" \
    --user="${JFROG_USER}" --password="${JFROG_PASSWORD}" \
    --url="${JFROG_URL}"

# show
jfrog rt show

# copy all files from current location
jfrog rt u "*" "${JFROG_LOCATION}/${group}/${vers}/" \
  --flat=false \
  --build-name="${build_name}" \
  --build-number="${build_number}"
#  --dry-run

# jfrog rt d "../build-output/*" libs-release-local/zipFiles/

echo ""
echo " Build Id:  ${build_number}"
echo " Build Url: ${build_name}"
echo " Build completed!!!"
echo ""


# write passed properties out
passKeyValProperties

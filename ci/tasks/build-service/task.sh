#!/bin/bash

set -e # fail fast
# set -x # print commands

export ROOT_FOLDER="$( pwd )"
export KEYVALOUTPUT_RESOURCE=keyvalout
propsDir="${ROOT_FOLDER}/${KEYVALOUTPUT_RESOURCE}"
propsFile="${propsDir}/keyval.properties"

mkdir -p "${ROOT_FOLDER}/${KEYVALOUTPUT_RESOURCE}"
touch "${propsFile}"


echo ""
echo " .. Running build"
echo ""
pipeline_id=""$( cat metadata/build-name )"
echo "Pipeline id is $pipeline_id"
export "PASSED_PIPELINE_ID=$pipeline_id"

for prop in "$(ls -1 ${ROOT_FOLDER}/metadata)";
do
  echo "$prop :- $(cat ${ROOT_FOLDER}/metadata/${prop})";
done;

export atc_external_url="$(cat metadata/atc-external-url)";
export build_id="$(cat metadata/build-id)";
export build_job_name="$(cat metadata/build-job-name)";
export build_name="$(cat metadata/build-name)";
export build_pipeline_name="$(cat metadata/build-pipeline-name)";
export build_team_name=$(cat metadata/build-team-name)";

echo "atc_external_url=${atc_external_url}" >> "${propsFile}"
echo "build_id=${atc_external_url}" >> "${propsFile}"
echo "build_job_name=${atc_external_url}" >> "${propsFile}"
echo "build_name=${atc_external_url}" >> "${propsFile}"
echo "build_pipeline_name=${atc_external_url}" >> "${propsFile}"
echo "build_team_name=${atc_external_url}" >> "${propsFile}"

echo "url - ${atc_external_url}"
echo "build-id - ${build_id}"
echo "job - ${build_job_name}"
echo "build - ${build_name}"
echo "pipeline - ${build_pipeline_name}"
echo "team - ${build_team_name}"

exit 1;

cd service-repo

# gradle build
export GRADLE_OPTS="-Dorg.gradle.native=false"
./gradlew clean test assemble

# create target folder
# mkdir -f ../build-output

# move all manifests file to target
cp manifest.yml  ../build-output/

cp build/libs/*.jar ../build-output/


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
cp -rfv build/reports  ../build-output/reports

# generate pdf documents from markdown and asciidocs
echo ""
echo " .. moving output files to Artifactory"
markdown-pdf *.md
mv *.pdf ../build-output

echo ""
echo " .. output files "
ls -l ../build-output

echo " .. TODO - need artifactory endpoints "

# TODO: CTS
# move the files from 'test-output' to Artifactory
#
#

# TODO - move to variables
group="com.sakx"
build_number="0.0.1-SNAPSHOT"
build_name="gs-actuator-service"

# jfrog target command-name global-options command-options arguments


jfrog rt config rt-server-1 --user=admin --password=password --url=http://artifactory:8081/artifactory
jfrog rt show
jfrog rt u "../build-output/*" "example-repo-local/${group}/${vers}/" --dry-run
#    --build-name="http://localhost:8080/teams/${BUILD_TEAM_NAME}/pipelines/${BUILD_PIPELINE_NAME}" \
#    --build-number="${BUILD_ID}" \

# jfrog rt d "../build-output/*" libs-release-local/zipFiles/

echo ""
echo " Build completed!!!"
echo ""

exit 1;

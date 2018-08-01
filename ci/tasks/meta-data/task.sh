#!/bin/sh

set -e # fail fast
# set -x # print commands

export ROOT_FOLDER="$( pwd )"
export REPO_RESOURCE="service-repo"
export KEYVALOUTPUT_RESOURCE=keyvalout

propsDir="${ROOT_FOLDER}/${KEYVALOUTPUT_RESOURCE}"
propsFile="${propsDir}/keyval.properties"

mkdir -p "${ROOT_FOLDER}/${KEYVALOUTPUT_RESOURCE}"
touch "${propsFile}"

echo ""
echo " .. Running 'meta-data' task"
echo ""

export PASSED_atc_external_url="$(cat metadata/atc-external-url)";
export PASSED_build_id="$(cat metadata/build-id)";
export PASSED_build_job_name="$(cat metadata/build-job-name)";
export PASSED_build_name="$(cat metadata/build-name)";
export PASSED_build_pipeline_name="$(cat metadata/build-pipeline-name)";
export PASSED_build_team_name="$(cat metadata/build-team-name)";

echo "PASSED_atc_external_url=${PASSED_atc_external_url}" >> "${propsFile}"
echo "PASSED_build_id=${PASSED_build_id}" >> "${propsFile}"
echo "PASSED_build_job_name=${PASSED_build_job_name}" >> "${propsFile}"
echo "PASSED_build_name=${PASSED_build_name}" >> "${propsFile}"
echo "PASSED_build_pipeline_name=${PASSED_build_pipeline_name}" >> "${propsFile}"
echo "PASSED_build_team_name=${PASSED_build_team_name}" >> "${propsFile}"
echo "PASSED_group=${GROUP}" >> "${propsFile}"

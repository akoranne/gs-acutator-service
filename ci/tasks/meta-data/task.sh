#!/bin/sh

set -e # fail fast
# set -x # print commands

export ROOT_FOLDER="$( pwd )"
export KEYVALOUTPUT_RESOURCE=keyvalout
propsDir="${ROOT_FOLDER}/${KEYVALOUTPUT_RESOURCE}"
propsFile="${propsDir}/keyval.properties"

mkdir -p "${ROOT_FOLDER}/${KEYVALOUTPUT_RESOURCE}"
touch "${propsFile}"

echo ""
echo " .. Running 'meta-data' task"
echo ""

export atc_external_url="$(cat metadata/atc-external-url)";
export build_id="$(cat metadata/build-id)";
export build_job_name="$(cat metadata/build-job-name)";
export build_name="$(cat metadata/build-name)";
export build_pipeline_name="$(cat metadata/build-pipeline-name)";
export build_team_name="$(cat metadata/build-team-name)";

echo "atc_external_url=${atc_external_url}" >> "${propsFile}"
echo "build_id=${build_id}" >> "${propsFile}"
echo "build_job_name=${build_job_name}" >> "${propsFile}"
echo "build_name=${build_name}" >> "${propsFile}"
echo "build_pipeline_name=${build_pipeline_name}" >> "${propsFile}"
echo "build_team_name=${build_team_name}" >> "${propsFile}"
echo "group=${GROUP}" >> "${propsFile}"

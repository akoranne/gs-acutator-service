#!/bin/bash

set -e # fail fast
# set -x # print commands

echo ""
echo " .. Running build"
echo ""

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
group="com.jh"
build_number="0.0.2-SNAPSHOT"
build_name="jh-policy-poc"

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
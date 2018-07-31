#!/bin/bash

set -o errexit
set -o errtrace
set -o pipefail

export TMPDIR=${TMPDIR:-/tmp}
export TEST_MODE="${TEST_MODE:-false}"

# Reads all key-value pairs in keyval.properties input file and exports them as env vars
function exportKeyValProperties() {
	props="${ROOT_FOLDER}/${KEYVAL_RESOURCE}/keyval.properties"
	echo "Props are in [${props}]"
	if [ -f "${props}" ]
	then
	  echo "Reading passed key values"
	  while IFS= read -r var
	  do
		if [ ! -z "${var}" ]
		then
			echo "Adding: ${var}"
			export "$var"
		fi
	  done < "${props}"
	fi
}

# Writes all env vars that begin with PASSED_ to the keyval.properties output file
function passKeyValProperties() {
	propsDir="${ROOT_FOLDER}/${KEYVALOUTPUT_RESOURCE}"
	propsFile="${propsDir}/keyval.properties"
	if [ -d "${propsDir}" ]
	then
	  touch "${propsFile}"
	  echo "Setting key values for next job in ${propsFile}"
	  while IFS='=' read -r name value ; do
		if [[ "${name}" == 'PASSED_'* ]]; then
			echo "Adding: ${name}=${value}"
			echo "${name}=${value}" >> "${propsFile}"
		fi
		done < <(env)
	fi
}

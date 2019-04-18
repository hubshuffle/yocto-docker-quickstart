#!/usr/bin/env bash

set -e

usage() {
  echo "Usage: $0 <target-directory>"
}

if [ $# -ne 1 ]; then
  usage
  exit 1
fi

directory=$1

if [ -e "${directory}" ]; then
  echo "Error: \"${directory}\" already exists."
  usage
fi

# create the directory
mkdir -p "${directory}/sources" && cd "${directory}"

# clone poky and other layers
git clone -b thud git://git.yoctoproject.org/poky.git sources/poky
git clone -b thud https://github.com/agherzan/meta-raspberrypi.git sources/meta-raspberrypi
git clone -b thud https://github.com/openembedded/meta-openembedded.git sources/meta-openembedded

echo "Done, type \"cd ${directory} && . ./sources/poky/oe-init-build-env\" to create the build environment"

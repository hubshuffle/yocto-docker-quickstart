#!/usr/bin/env bash

set -e

mkdir -p workspace/yocto/layers && cd workspace/yocto
git clone -b thud git://git.yoctoproject.org/poky.git
cd layers
git clone -b thud https://github.com/agherzan/meta-raspberrypi.git
git clone -b thud https://github.com/openembedded/meta-openembedded.git
cd ../../

# Yocto Docker Quick Starter
## This repository contains kick starter components for Yocto development using a Docker image.

Components description:
* start.sh:
    * Run this script from this directory in order to enter the Docker Yocto environment.
* docker/Dockerfile:
    * Optionally you can build the docker image with this file. If you do so you have to edit start.sh with the docker
    image ID you've built.
* cache:
    * This directory contains the locations used as Docker volume targets for the Yocto DL_DIR and SSTATE_DIR
    components.
* home:
    * This directory is the Docker volume target for the home directory. It allows you to add persistence mainly for
    bash history and ssh keys.
* clone-yocto.sh:
    * Run this script to clone the yocto repository.

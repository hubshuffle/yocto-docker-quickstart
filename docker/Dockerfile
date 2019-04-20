# this image augments Ubuntu 16.04 with the minimum necessary to run Yocto with support for QEMU and devtool
FROM ubuntu:16.04
MAINTAINER hubshuffle <hubshuffled@gmail.com`>

# Upgrade system, add Yocto Proyect basic dependencies and extras
RUN apt-get update && apt-get -y upgrade && apt-get -y install kmod gawk wget git-core diffstat unzip texinfo \
gcc-multilib build-essential chrpath socat cpio python python3 python3-pip python3-pexpect xz-utils debianutils \
iputils-ping libsdl1.2-dev xterm curl vim tzdata

# for tunctl (qemu)
RUN apt-get -y install uml-utilities

# for toaster
RUN apt-get -y install python-virtualenv daemon

# for package feeds
RUN apt-get -y install lighttpd

# for bitbake -g
RUN apt-get -y install python3-gi python-pip python3-aptdaemon.gtk3widgets

# Set up locales
RUN apt-get -y install locales apt-utils sudo && dpkg-reconfigure locales && locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.utf8

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Replace dash with bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install repo
RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo && chmod a+x /usr/local/bin/repo

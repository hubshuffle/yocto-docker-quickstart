#!/usr/bin/env bash

set -e

usage() {
  echo "Usage:"
  echo "$0 <options>"
  echo "Available options:"
  echo "-x    Use X11 forwarding"
  echo "-n    Forward /dev/net/tun"
  echo "-p    Run container in privileged mode"
  echo "-e    Execute additional instance"

  exit 0
}

# rough check to see if we are in correct directory
dirs_to_check=( "./cache/downloads" "./cache/sstate" "./home" )
for d in "${dirs_to_check[@]}"; do
  if [[ ! -d ${d} ]]; then
    echo "\"${d}\" directory not found"
    usage
  fi
done

arg_privileged=""
set_arg_privileged() {
  echo "WARNING: Running the container with privileged access"
  arg_privileged="--privileged"
}

arg_x11_forward=""
set_arg_x11() {
  xhost +	
  arg_x11_forward="--env DISPLAY=unix${DISPLAY} \
--volume ${XAUTH}:/root/.Xauthority \
--volume /tmp/.X11-unix:/tmp/.X11-unix "
}

arg_net_forward=""
tun_dev="/dev/net/tun"
set_arg_net() {
  arg_net_forward="--cap-add=NET_ADMIN \
--device ${tun_dev}:/dev/net/tun 
--publish 8000:8000"
}

run_additional_instance=false
# parse input arguments
while getopts ":hxnpe" opt; do
  case ${opt} in
    h )
      usage
      ;;
    x )
      command -v xhost >/dev/null 2>&1 || { echo >&2 "\"xhost\" is not installed"; exit 1; }
      set_arg_x11
      ;;
    n )
      [[ -e "${tun_dev}" ]] || { echo >&2 "\"${tun_dev}\" not found, is the \"tun\" kernel module loaded?"; exit 1; }
      set_arg_net
      ;;
    p )
      set_arg_privileged
      ;;
    e )
      run_additional_instance=true
      ;;
    \? )
      echo "Invalid Argument: \"${opt}\"" 1>&2
      usage
      ;;
  esac
done

empty_password_hash="U6aMy0wojraho"

if [ "${run_additional_instance}" = true ]; then
    docker container exec \
        -it \
        --user yocto \
        -w /opt/yocto/workspace \
        hubshuffle-yocto \
        /bin/bash
else
    docker container run \
        -it \
        --rm \
        -v "${PWD}":/opt/yocto \
        --name hubshuffle-yocto \
        ${arg_net_forward} \
        ${arg_x11_forward} \
        ${arg_privileged} \
        --volume "${PWD}/home":/home/yocto \
        hubshuffle/yocto:1.2 \
        sudo bash -c "groupadd -g 7777 yocto && useradd --password ${empty_password_hash} --shell /bin/bash -u ${UID} -g 7777 \
        yocto && usermod -aG sudo yocto && usermod -aG users yocto && cd /opt/yocto && su yocto"
fi

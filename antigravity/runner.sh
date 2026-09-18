#!/bin/bash -u
#
# Copyright 2026 Misha Brukman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Tooling
CONTAINER_TOOL="podman"

# Build-time args
CONTAINER_IMAGE_NAME="${CONTAINER_NAME:-antigravity-ide}"
UNAME="ubuntu"  # Matches Ubuntu 26.04 default in Containerfile
UID_IN_CONTAINER="${UID:-$(id -u)}"

# Run-time params
CONTAINER_RUN_NAME="${CONTAINER_RUN_NAME:-run-antigravity-ide}"
CONTAINER_RUN_FLAGS="${CONTAINER_RUN_FLAGS:-}"
ANTIGRAVITY_IDE_INSTALL="/opt/antigravity-ide"
MAPPED_HOME_DIR="/home/${USER}"

# Optional param overrides
if [ -e "local.sh" ]; then
  . "./local.sh"
fi

# Build the container.
build() {
  "${CONTAINER_TOOL}" build \
      --build-arg UNAME="${UNAME}" \
      -t "${CONTAINER_IMAGE_NAME}" \
      -f Containerfile
}

run() {
  "${CONTAINER_TOOL}" run \
      -it \
      --device=/dev/dri \
      --env=DISPLAY \
      --env=XDG_RUNTIME_DIR="/run/user/${UID_IN_CONTAINER}" \
      --env=XDG_SESSION_TYPE=wayland \
      --env=WAYLAND_DISPLAY="${WAYLAND_DISPLAY}" \
      --ipc=host \
      --net=host \
      --userns=keep-id \
      --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
      --volume="/var/run/dbus/system_bus_socket:/run/dbus/system_bus_socket:ro" \
      --volume="/run/user/${UID_IN_CONTAINER}/${WAYLAND_DISPLAY}:/run/user/${UID_IN_CONTAINER}/${WAYLAND_DISPLAY}:ro" \
      --volume="${XDG_RUNTIME_DIR}:/run/user/${UID}:rw" \
      --volume="${ANTIGRAVITY_IDE_INSTALL}:/opt/antigravity-ide:z" \
      --volume="${MAPPED_HOME_DIR}:/home/${UNAME}:rw,z" \
      ${CONTAINER_RUN_FLAGS} \
      "${CONTAINER_IMAGE_NAME}" \
      ${RUN_CMD:-}
}

shell() {
  env RUN_CMD="/bin/bash" "$0" run
}

# Run function named by the first param
case "${1:-}" in
  build)
    build
    ;;
  run)
    run
    ;;
  shell)
    shell
    ;;
  *)
    echo "Invalid command: '${1:-}'; available: build, run, shell" >&2
    exit 1
    ;;
esac

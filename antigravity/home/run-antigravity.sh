#!/bin/bash
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

readonly TMUX_SESSION="agy"
readonly TMUX_WINDOW="Agy"

readonly ANTIGRAVITY_APP="/opt/antigravity/antigravity"
readonly ANTIGRAVITY_IDE="/opt/antigravity-ide/antigravity-ide"
agy_binary=""

case "${ANTIGRAVITY,,}" in
  app)
    if ! [[ -f "${ANTIGRAVITY_APP}" ]]; then
      echo "No Antigravity app found at ${ANTIGRAVITY_APP}" >&2
      exit 1
    fi
    agy_binary="${ANTIGRAVITY_APP}"
    ;;
  ide)
    if ! [[ -f "${ANTIGRAVITY_IDE}" ]]; then
      echo "No Antigravity IDE found at ${ANTIGRAVITY_IDE}" >&2
      exit 2
    fi
    agy_binary="${ANTIGRAVITY_IDE}"
    ;;
  *)
    cat >&2 <<EOF
Antigravity mode not specified via env var \${ANTIGRAVITY};
expected either 'app' or 'ide'.
EOF
    exit 3
    ;;
esac

# Antigravity requires D-Bus:
# https://antigravity.google/docs/cli/troubleshooting/#authorize-keyring-permissions
#
# Using the Wayland approach here instead of the X11 approach since Ubuntu
# 26.04 defaults to Wayland.
#
# Disabling GPU as it seems to error on startup.
tmux new-session -s "${TMUX_SESSION}" -d \; \
    new-window -n "${TMUX_WINDOW}" \
        "/usr/bin/dbus-run-session -- ${agy_binary} --disable-gpu" \; \
    attach-session -t "${TMUX_SESSION}"

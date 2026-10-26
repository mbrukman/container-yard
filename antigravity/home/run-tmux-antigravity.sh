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

agy_script=""

case "${ANTIGRAVITY,,}" in
  app)
    agy_script="$(dirname $0)/antigravity.sh"
    ;;
  ide)
    agy_script="$(dirname $0)/antigravity-ide.sh"
    ;;
  *)
    cat >&2 <<EOF
Antigravity mode not specified via env var \${ANTIGRAVITY};
expected either 'app' or 'ide'.
EOF
    exit 1
    ;;
esac

tmux new-session -s "${TMUX_SESSION}" -d \; \
    new-window -n "${TMUX_WINDOW}" "${agy_script}" \; \
    attach-session -t "${TMUX_SESSION}"

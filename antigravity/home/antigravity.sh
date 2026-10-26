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

# Antigravity requires D-Bus:
# https://antigravity.google/docs/cli/troubleshooting/#authorize-keyring-permissions
#
# Using the Wayland approach here instead of the X11 approach since Ubuntu
# 26.04 defaults to Wayland.
#
# Disabling GPU as it seems to error on startup.
/usr/bin/dbus-run-session -- /opt/antigravity/antigravity --disable-gpu

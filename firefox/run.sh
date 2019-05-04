#!/bin/sh -e
# Copyright 2019 Red Hat
# This file is part of copperblue.
#
# Copperblue is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Copperblue is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with copperblue.  If not, see <https://www.gnu.org/licenses/>.

# If first arg is a date, use it as a tag
if [[ "$1" =~ [0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
    TAG=$1
    shift
fi
APP=firefox
ARGS=(
    # Delete container when we are done
    --rm
    # Disable SELinux label to enable mounting host volume
    --security-opt label=disable
    # Mount persistent config
    -v ~/.copperblue/${APP}/:/root
    # Share X11
    -v ~/.Xauthority:/root/.Xauthority
    -v /tmp/.X11-unix/:/tmp/.X11-unix/
    -e DISPLAY=:0
    # Share pulseaudio
    -v /tmp/.X11-unix/:/tmp/.X11-unix/
    -v /run/user/1000/:/run/user/1000/
    -e XDG_RUNTIME_DIR=/run/user/1000
    -e PULSE_SERVER=/run/user/1000/pulse/native
    # Start in home
    -w /root/
    # The image name
    localhost/${APP}:${TAG:-latest}
    # The command
    firefox --no-remote
)
echo -n "Running: "
set -x
exec podman run ${ARGS[@]} $*
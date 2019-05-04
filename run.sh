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

APP_DIR=$1
if test -z ${APP_DIR} || ! test -d ${APP_DIR}; then
    echo "usage: $0 app-folder"
    exit 1
fi
APP=$(basename $(realpath ${APP_DIR}))
shift

# Ensure buildah and podman are installed
if ! type -p buildah > /dev/null || ! type -p podman > /dev/null; then
    sudo dnf install -y buildah podman
fi

# Create application home directory
if ! test -d ~/.copperblue/${APP}; then
    mkdir -p ~/.copperblue/${APP}
fi

# Ensure base-layer is built
if ! buildah images -nq localhost/base-layer:latest &> /dev/null; then
    buildah bud -f Buildahfile -t base-layer:latest base-layer
fi

# Build image if needed
if ! buildah images -nq localhost/${APP}:latest &> /dev/null; then
    DATE=$(date "+%Y-%m-%d")
    buildah bud -f Buildahfile -t $APP:$DATE $APP_DIR
    buildah tag $APP:$DATE $APP:latest
fi

exec $APP_DIR/run.sh $*

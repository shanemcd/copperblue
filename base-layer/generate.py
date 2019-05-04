#!/bin/env python3
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

import subprocess

common = ["strace", "alsa-plugins-pulseaudio", "pulseaudio-libs"]
images = ["emacs", "firefox"]

def pkglist(image):
    print("Collecting the packages of the image %s" % image)
    p = subprocess.Popen(["podman", "run", "--rm", image, "rpm", "-qia"], stdout=subprocess.PIPE)
    stdout, _ = p.communicate()
    return list(
            map(lambda x: x.split(': ')[1],
             filter(lambda x: x.startswith('Name ') and
                 (image == "fedora" or image not in x),
                 stdout.decode('utf-8').split('\n'))))

existing = pkglist("fedora")
for image in images:
    common.extend(pkglist(image))
common = sorted(set(filter(lambda x: x not in existing, common)))
print("Found %d common packages" % len(common))
with open("Buildahfile", "w") as of:
    of.write("""# Do not update this file, run the generate.py script
FROM fedora:30
RUN dnf install -y \\\n %s
""" % (" \\\n ".join(common)))

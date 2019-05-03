CopperBlue - A lightweight silverblue desktop
=============================================

CopperBlue aims at providing an efficient container based desktop
for powerusers without the bells and whisle of gnome/flatpak.

# System

From a Silverblue system, install Copperblue by running:

```
# Create a new ostree repo:
sudo ostree init --repo=/ostree/copperblue

# Compose the copperblue tree:
pushd system
git submodule update --init
sudo rpm-ostree compose tree -r /ostree/copperblue --workdir /ostree/copperblue/tmp copperblue.yaml
popd

# Copy the tree in system ostree repo:
sudo ostree pull-local /ostree/copperblue fedora/rawhide/x86_64/copperblue

# Install the tree:
sudo ostree admin deploy fedora/rawhide/x86_64/copperblue
```

# Applications

From a Fedora based system, use the applications by simply running the run script:

```
./run.sh mumble
```

Which is equivalent to:

```
buildah bud -f Buildahfile -t mumble:latest mumble
./mumble/run.sh
```

Update the application by running:
```
app=mumble
date=$(date "+%Y-%m-%d")

# Update the image
buildah from $app:latest
buildah run $app-working-container dnf update -y
buildah commit $app-working-container $app:$date
./$app/run.sh $date

# If the update worked
buildah tag $app:$date $app:latest
# Else
buildah rmi $app:$date
```

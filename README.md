CopperBlue - A lightweight silverblue desktop
=============================================

CopperBlue aims at providing an efficient container based desktop
for powerusers without the bells and whisle of gnome/flatpak.

From a Silverblue system, install Copperblue by running:

```
# Create a new ostree repo:
sudo ostree init --repo=/ostree/copperblue

# Compose the copperblue tree:
git submodule update --init
sudo rpm-ostree compose tree -r /ostree/copperblue --workdir /ostree/copperblue/tmp copperblue.yaml

# Copy the tree in system ostree repo:
sudo ostree pull-local /ostree/copperblue fedora/30/x86_64/copperblue

# Install the tree:
sudo ostree admin deploy fedora/30/x86_64/copperblue
```

When the rpm-ostree compose fail, you may have to re-create the ostree repo:

```
rm -Rf /ostree/copperblue && sudo ostree init --repo=/ostree/copperblue
```

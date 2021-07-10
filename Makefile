all:
	rpm-ostree compose tree --unified-core -r /ostree/copperblue copperblue.yaml
	ostree pull-local /ostree/copperblue fedora/34/x86_64/copperblue
	ostree admin deploy fedora/34/x86_64/copperblue

clean:
	rm -Rf /ostree/copperblue
	ostree init --repo=/ostree/copperblue

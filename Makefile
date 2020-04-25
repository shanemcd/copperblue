all:
	rpm-ostree compose tree -r /ostree/copperblue --workdir /ostree/copperblue/tmp copperblue.yaml
	ostree pull-local /ostree/copperblue fedora/32/x86_64/copperblue
	ostree admin deploy fedora/32/x86_64/copperblue

clean:
	rm -Rf /ostree/copperblue
	ostree init --repo=/ostree/copperblue

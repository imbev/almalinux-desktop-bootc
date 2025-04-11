SUDO = sudo
PODMAN = $(SUDO) podman

MAJOR = 10-kitten
VARIANT = gnome
ARCH = x86_64

.PHONY: \
	bootc-image \
	installer \
	clean

bootc-image:
	$(PODMAN) build \
		-t quay.io/almalinuxorg/almalinux-bootc:$(MAJOR)-$(VARIANT)-bootc \
		-f $(MAJOR)/$(VARIANT)/Containerfile \
		.

installer:
	curl \
		-LO \
		https://repo.almalinux.org/almalinux/10.0-beta/isos/$(ARCH)/AlmaLinux-10-latest-beta-$(ARCH)-boot.iso

	echo "f0bf7fb6a81a506a4adc56f2537ae53ee9ad4b7ace1b74cf344a100772e10874 AlmaLinux-10-latest-beta-$(ARCH)-boot.iso" \
		| sha256sum --check

	$(PODMAN) run \
		--rm \
		-v ${PWD}:/pwd:z \
		-e ARCH=$(ARCH) \
		-e MAJOR=$(MAJOR) \
		-e VARIANT=$(VARIANT) \
		quay.io/almalinuxorg/almalinux-bootc:10-kitten \
		/pwd/scripts/installer-patch.sh
clean:
	-$(PODMAN) rmi $(IMAGE):10-kitten-gnome-bootc
	-$(PODMAN) rmi $(IMAGE):10-kitten-plasma-bootc
	-$(SUDO) rm -rf ./output
	-$(SUDO) rm ./*.iso

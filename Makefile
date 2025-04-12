SUDO = sudo
PODMAN = $(SUDO) podman

MAJOR = 10-kitten
VARIANT = gnome
ARCH = x86_64
IMAGE_NAME ?= localhost/almalinux-$(VARIANT)
IMAGE_TAG ?= latest
IMAGE_TYPE ?= iso
IMAGE_CONFIG ?= iso.toml

.PHONY: \
	bootc \
	installer \
	image \
	image-iso \
	image-qcow2 \
	run-qemu-qcow \
	run-qemu-iso \
	clean

bootc:
	$(PODMAN) build \
		--platform=$(ARCH) \
		--security-opt=label=disable \
		--cap-add=all \
		--device /dev/fuse \
		-t $(IMAGE_NAME) \
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

image: bootc
	#rm -rf ./output
	mkdir -p ./output

	IMAGE_NAME=$(IMAGE_NAME) IMAGE_TAG=$(IMAGE_TAG) envsubst < $(IMAGE_CONFIG) > ./output/config.toml

	# AlmaLinux's repos are configured with mirrorlist and apparently that stops you from building ISOs with librepo=true
	# https://github.com/osbuild/bootc-image-builder/issues/883
	@sh -c '\
		if [ "$(IMAGE_TYPE)" = "iso" ]; then \
			LIBREPO=False; \
		else \
			LIBREPO=True; \
		fi; \
		$(PODMAN) run \
			--rm \
			-it \
			--privileged \
			--pull=newer \
			--security-opt label=type:unconfined_t \
			-v ./output/config.toml:/config.toml:ro \
			-v ./output:/output \
			-v /var/lib/containers/storage:/var/lib/containers/storage \
			quay.io/centos-bootc/bootc-image-builder:latest \
			--type $(IMAGE_TYPE) \
			--use-librepo=$$LIBREPO \
			$(IMAGE_NAME):$(IMAGE_TAG) \
	'

	$(SUDO) chown -R $(USER):$(USER) ./output

image-iso:
	make image IMAGE_TYPE=iso

image-qcow2:
	make image IMAGE_TYPE=qcow2

run-qemu-qcow: image-qcow2
	qemu-system-x86_64 \
		-M accel=kvm \
		-cpu host \
		-smp 2 \
		-m 4096 \
		-bios /usr/share/OVMF/x64/OVMF.4m.fd \
		-serial stdio \
		-snapshot ./output/qcow2/disk.qcow2

run-qemu-iso: image-iso
	# Make a disk to install to
	[[ ! -e ./output/disk.raw ]] && dd if=/dev/null of=./output/disk.raw bs=1M seek=10240

	qemu-system-x86_64 \
		-M accel=kvm \
		-cpu host \
		-smp 2 \
		-m 4096 \
		-bios /usr/share/OVMF/x64/OVMF.4m.fd \
		-serial stdio \
		-boot d \
		-cdrom ./output/bootiso/install.iso \
		-hda ./output/disk.raw

clean:
	-$(PODMAN) rmi $(IMAGE_NAME)
	-$(SUDO) rm -rf ./output
	-$(SUDO) rm ./*.iso

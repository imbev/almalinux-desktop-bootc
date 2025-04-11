FROM quay.io/almalinuxorg/almalinux-bootc:10-kitten

COPY scripts /scripts

RUN /scripts/epel-repo.sh

RUN /scripts/gnome-desktop.sh

RUN /scripts/dnf-clean.sh

RUN /scripts/bootc-update-noapply.sh

RUN rm -rf /scripts

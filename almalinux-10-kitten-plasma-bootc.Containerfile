FROM quay.io/almalinuxorg/almalinux-bootc:10-kitten

COPY scripts /scripts

RUN /scripts/epel-repo.sh

RUN /scripts/plasma-desktop.sh

RUN /scripts/console-login-helper-messages-remove.sh

RUN /scripts/dnf-clean.sh

RUN /scripts/bootc-update-noapply.sh

RUN rm -rf /scripts

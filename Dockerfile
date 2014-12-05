FROM boot2docker/boot2docker
MAINTAINER Everton Ribeiro <everton@azukiapp.com>

ENV ROOTFS          /rootfs
ENV TCZ_DEPS        fuse

# Install the TCZ dependencies
RUN for dep in $TCZ_DEPS; do \
    echo "Download $TCL_REPO_BASE/tcz/$dep.tcz" &&\
        curl -L -o /tmp/$dep.tcz $TCL_REPO_BASE/tcz/$dep.tcz && \
        unsquashfs -f -d $ROOTFS /tmp/$dep.tcz && \
        rm -f /tmp/$dep.tcz ;\
    done

# Install bindfs
ADD bindfs.tcz /tmp/bindfs.tcz
RUN unsquashfs -f -d $ROOTFS /tmp/bindfs.tcz && rm -f /tmp/bindfs.tcz

# Copy our custom rootfs
COPY rootfs/rootfs $ROOTFS

# Change MOTD
RUN mv $ROOTFS/usr/local/etc/motd $ROOTFS/etc/motd

# Copy boot params
COPY rootfs/isolinux /tmp/iso/boot/isolinux

# Generate image
RUN /make_iso.sh
CMD ["cat", "boot2docker.iso"]

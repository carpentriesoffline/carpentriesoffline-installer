from ubuntu:22.04 


RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata \
    unzip git wget qemu-system-arm qemu-efi expect vim-tiny fdisk e2fsprogs mtools zip xz-utils && \
    mkdir /output && \
    mkdir /build_img

COPY build_img.sh /build_img
COPY *.exp /build_img/

ENTRYPOINT build_img/build_img.sh /output


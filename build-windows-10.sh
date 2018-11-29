#!/usr/bin/env bash

#export NAME="windows-10-enterprise"
export WINDOWS_VERSION="10"

#export VIRTIO_WIN_ISO="./iso/virtio-win-0.1.160.iso"

#export ISO_URL="./iso/en_windows_10_enterprise_version_1703_updated_july_2017_x64_dvd_10925376.iso"
#export ISO_CHECKSUM="57e336f03768a297e0f28a87f467af83f4b06e3cca98bcf5ab5232c1f0d3da52"

#export PACKER_IMAGES_OUTPUT_DIR="/var/tmp/"

PACKER_LOG=1 packer build -only=qemu -var-file=variable.json windows.json
#PACKER_LOG=1 packer build -only=qemu windows.json

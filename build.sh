#!/bin/bash
set -o errexit

QEMU_VERSION=6.2.0

docker build . \
    --build-arg QEMU_VERSION="${QEMU_VERSION}" \
    --output type=local,dest=.

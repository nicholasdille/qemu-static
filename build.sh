#!/bin/bash
set -o errexit

QEMU_VERSION=6.2.0

docker build . \
    --env QEMU_VERSION \
    --output type=local,dest=.

FROM ubuntu:20.04 AS build

ENV DEBIAN_FRONTEND=non-interactive
RUN apt-get update \
 && apt-get -y install --no-install-recommends \
        build-essential \
        ninja-build \
        git \
        ca-certificates \
        libglib2.0-dev \
        libfdt-dev \
        libpixman-1-dev \
        zlib1g-dev \
 && rm /usr/local/sbin/unminimize

ARG QEMU_VERSION=7.0.0
ARG TARGETS="aarch64-softmmu x86_64-softmmu"
WORKDIR /tmp/qemu
RUN git clone -q --config advice.detachedHead=false --depth 1 --branch "v${QEMU_VERSION}" https://github.com/qemu/qemu .
WORKDIR /tmp/qemu/build
RUN ../configure --prefix=/usr/local --static --enable-tools --disable-user --target-list="${TARGETS}" \
 && make
RUN make install

FROM scratch
COPY --from=build /usr/local/ /usr/local
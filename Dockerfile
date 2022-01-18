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
        zlib1g-dev

ARG QEMU_VERSION
RUN if test -z "${QEMU_VERSION}"; then \
        echo "ERROR: Build argument QEMU_VERSION must be set."; \
    fi
WORKDIR /tmp/qemu
RUN git clone -q --config advice.detachedHead=false --depth 1 --branch "v${QEMU_VERSION}" https://github.com/qemu/qemu .
WORKDIR /tmp/qemu/build
RUN ../configure --prefix=/usr/local --static --enable-tools --disable-user --target-list="aarch64-softmmu x86_64-softmmu" \
 && make
RUN make install

FROM scratch
COPY --from=build /usr/local/ /usr/local
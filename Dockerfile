FROM ubuntu:18.04 AS builder

RUN apt-get update && \
    apt-get install -y curl libblockdev-btrfs-dev libseccomp-dev zfsutils-linux git \
                            wget unzip && \
    rm -rf /var/lib/apt/lists/* 

ENV GOLANG_VERSION=1.13.5 \
    GOROOT=/usr/local/go \
    GOPATH=/go \
    PATH=/usr/local/go/bin:/go/bin:$PATH

RUN curl -sSL https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz \
		| tar -v -C /usr/local -xz && \
    mkdir -p /go/src /go/bin && chmod -R 777 /go

ARG K3S_GIT_BRANCH=release/v1.0

RUN cd /go && git clone https://github.com/rancher/k3s.git --branch ${K3S_GIT_BRANCH} --single-branch k3s
WORKDIR /go/k3s
# To run git-apply the patches cannot exist outside of the git repo.
# We can safely place it into build/ as this already added to .gitignore
COPY patches build/patches

# A comma seperates list of patches to apply
ARG APPLY_PATCHES_CSV=enable_zfs
RUN set -e; for p in $(echo $APPLY_PATCHES_CSV | tr "," "\n"); \
        do git apply "build/patches/${p}.patch" && echo "applied ${p}"; \
    done && \
    ./scripts/download && ./scripts/build && ./scripts/package-cli

#
# Discard the 3.8 gigabyte builder image
#
FROM ubuntu:18.04

COPY --from=builder /go/k3s/dist/artifacts/k3s /usr/local/bin/

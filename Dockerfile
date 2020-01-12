FROM ubuntu:16.04

VOLUME ["/code"]
WORKDIR /code

ENV BOLOS_ENV /opt/bolos-env
ENV BOLOS_SDK /opt/bolos-sdk

ARG SDK_VER

RUN echo "Building image for ledger sdk version ${SDK_VER}" && \
    apt update && apt upgrade -y && \
    apt install -y --no-install-recommends sudo libc6-dev-i386 make python3 python3-pil && \
    mkdir ${BOLOS_ENV} && mkdir ${BOLOS_SDK} && \
    groupadd --gid 1000 docker && \
    useradd --uid 1000 --gid 1000 --no-create-home --home-dir / docker && \
    usermod -aG sudo docker && echo "docker ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/docker
    
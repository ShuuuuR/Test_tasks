ARG RUST_VERSION=1.85
FROM rust:${RUST_VERSION}-slim AS builder
ARG AGAVE_VERSION=v2.1.15

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    libssl-dev \
    libudev-dev \
    pkg-config \
    zlib1g-dev \
    llvm \
    clang \
    cmake \
    make \
    libprotobuf-dev \
    protobuf-compiler \
    libclang-dev \
&& rm -rf /var/lib/apt/lists/* \
&& git clone --branch "$AGAVE_VERSION" --depth 1 https://github.com/anza-xyz/agave.git . \
&& rustup component add rustfmt \
&& rustup update \
&& cargo build --release 

FROM debian:bookworm-slim

ARG AGAVE_VERSION
ARG BINARY_PATH=/app/target/release/agave-validator
ARG INSTALL_PATH=/app/agave-validator

WORKDIR /app

COPY --from=builder $BINARY_PATH $INSTALL_PATH

ENTRYPOINT ["/app/agave-validator"]

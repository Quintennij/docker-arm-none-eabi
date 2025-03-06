ARG UBUNTU_VERSION=latest
FROM ubuntu:$UBUNTU_VERSION
ARG UBUNTU_VERSION

ARG DIR=10.3-2021.10
ARG FILE=gcc-arm-none-eabi-10.3-2021.10
ARG OUTFILE=gcc-arm-none-eabi-10.3-2021.10 ARG ARCHI=x86_64-linux

LABEL maintainer="srz_zumix <https://github.com/srz-zumix>"

ENV DEBIAN_FRONTEND=noninteractive
# Install dependencies and cppcheck
RUN dpkg --add-architecture i386 && \
  apt-get update && apt-get -y --no-install-recommends install \
    ca-certificates \
    build-essential clang libc6:i386 \
    bzip2 \
    git \
    cmake make \
    cppcheck \
    python3 \
    python3-pip \
    python-is-python3 \
    vim-common astyle \
    wget \
    unzip \
    && \
  pip install cppcheck-junit --break-system-packages && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install arm-none-eabi toolchain
RUN mkdir -p /usr/local/ && \
  echo "DIR=$DIR" && \
  echo "FILE=$FILE" && \
  echo "ARCHI=$ARCHI" && \
  wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/$DIR/$FILE-$ARCHI.tar.bz2 && \
  tar -xf $FILE-$ARCHI.tar.bz2 -C /usr/local/ && rm *.tar.bz2 && \
  apt-get clean

ENV PATH=$PATH:/usr/local/$OUTFILE/bin

# Install ninja build tool
RUN mkdir /ninja && \
    cd /ninja && \
    wget https://github.com/ninja-build/ninja/releases/download/v1.12.1/ninja-linux.zip && \
    unzip ninja-linux.zip

ENV PATH=$PATH:/ninja

ENV CC=arm-none-eabi-gcc \
    CXX=arm-none-eabi-g++ \
    CMAKE_C_COMPILER=arm-none-eabi-gcc \
    CMAKE_CXX_COMPILER=arm-none-eabi-g++ \
    STRIP=arm-none-eabi-strip \
    RANLIB=arm-none-eabi-ranlib \
    AS=arm-none-eabi-as \
    AR=arm-none-eabi-ar \
    LD=arm-none-eabi-ld \
    FC=arm-none-eabi-gfortran
ENV LD_LIBRARY_PATH=/usr/local/$OUTFILE/lib


RUN mkdir -p /app
WORKDIR /app

FROM ubuntu:20.04

ENV HOME /root
# Define working directory.
WORKDIR /root

## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

## preesed tzdata, update package index, upgrade packages and install needed software
RUN truncate -s0 /tmp/preseed.cfg; \
    echo "tzdata tzdata/Areas select Europe" >> /tmp/preseed.cfg; \
    echo "tzdata tzdata/Zones/Europe select Berlin" >> /tmp/preseed.cfg; \
    debconf-set-selections /tmp/preseed.cfg && \
    rm -f /etc/timezone /etc/localtime


RUN apt-get update && \
    apt-get install -y \
        build-essential \
		curl \
        git \
        bison \
        flex \
        libpcap-dev \
        libtool \
        libtool-bin \
		autoconf \
		pkg-config \
		automake \
		autogen \
		libjson-c-dev \
		libnuma-dev \
		libgcrypt20-dev \
		libpcre2-dev
		

## cleanup of files from setup
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -kL https://github.com/ntop/nDPI/archive/refs/tags/4.0.tar.gz | tar -xvz && \
	cd /root/nDPI-4.0 && \
    ./autogen.sh && \
    ./configure &&  \
    make && \
    make install

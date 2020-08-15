FROM alpine:3.12 as builder

RUN apk add --update --no-cache \
    autoconf \
    automake \
    binutils \
    boost-dev \
    boost-python3 \
    build-base \
    cppunit-dev \
    git \
    libtool \
    linux-headers \
    ncurses-dev \
    openssl-dev \
    python3-dev \
    zlib-dev \
  && rm -rf /tmp/* /var/cache/apk/*

ENV LIBTORRENT_VERSION="1.2.8"

RUN cd /tmp \
  && git clone --branch libtorrent-${LIBTORRENT_VERSION} https://github.com/arvidn/libtorrent.git \
  && cd libtorrent \
  && ./autotool.sh \
  && ./configure \
    --with-libiconv \
    --enable-python-binding \
    --with-boost-python="$(ls -1 /usr/lib/libboost_python3*.so* | sort | head -1 | sed 's/.*.\/lib\(.*\)\.so.*/\1/')" \
    PYTHON="$(which python3)" \
  && make -j$(nproc) \
  && make install-strip \
  && ls -al /usr/local/lib/

RUN apk add --update --no-cache \
    qt5-qtbase \
    qt5-qttools-dev \
  && rm -rf /tmp/* /var/cache/apk/*

ENV QBITTORRENT_VERSION="4.2.5"

RUN cd /tmp \
  && git clone --branch release-${QBITTORRENT_VERSION}  https://github.com/qbittorrent/qBittorrent.git \
  && cd qBittorrent \
  && ./configure --disable-gui \
  && make -j$(nproc) \
  && make install \
  && ls -al /usr/local/bin/ \
  && qbittorrent-nox --help

# based on alpine
FROM alpine:3.12

# copy qbit from build
COPY --from=builder /usr/local/lib/libtorrent-rasterbar.so.10.0.0 /usr/lib/libtorrent-rasterbar.so.10
COPY --from=builder /usr/local/bin/qbittorrent-nox /usr/bin/qbittorrent-nox

# Add packages
RUN apk --update --no-cache add \
    bind-tools \
    curl \
    openssl \
    qt5-qtbase \
    shadow \
    su-exec \
    tzdata \
    zlib \
    wireguard-tools \
    iptables \
    bash \
    && rm -rf /tmp/* /var/cache/apk/*


# copy defaults
COPY root/root/ /default

# Prepare entrypoint
copy entrypoint.sh /entrypoint.sh
RUN chmod 700 /entrypoint.sh

# Expose ports for qbittorrent webui
EXPOSE 8081

# volumes
VOLUME ["/etc/wireguard", "/config"]

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:8081/ || exit 1

ENTRYPOINT [ "/entrypoint.sh" ]

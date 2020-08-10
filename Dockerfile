# based on ubuntu
FROM alpine:latest

# Add curl
RUN apk --no-cache add wireguard-tools iptables 
RUN apk --no-cache add qbittorrent-nox --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing

# copy placeholder config files and startup script from host
COPY root/ /

RUN chmod 700 /entrypoint.sh

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:8080/ || exit 1

ENTRYPOINT [ "/entrypoint.sh" ]
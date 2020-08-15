FROM ubuntu:20.04

# Add curl
RUN apt update -y
RUN DEBIAN_FRONTEND="noninteractive" apt install iptables iproute2 wireguard bash qbittorrent-nox openresolv net-tools -y

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# copy placeholder config files and startup script from host
copy entrypoint.sh /entrypoint.sh
COPY root/root/ /default

RUN chmod 700 /entrypoint.sh

# Expose ports for qbittorrent webui
EXPOSE 8081

# volumes
VOLUME ["/etc/wireguard"]

#HEALTHCHECK --interval=5m --timeout=3s \
#  CMD curl -f http://localhost:8081/ || exit 1

ENTRYPOINT [ "/entrypoint.sh" ]

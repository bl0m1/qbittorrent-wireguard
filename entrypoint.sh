#!/bin/bash

INTERFACE="wg0"

# check for wireguard config, then start wireguard
if [ ! -f /etc/wireguard/"$INTERFACE".conf ]
then
    echo "[error] Could not find /etc/wireguard/"$INTERFACE".conf, exiting ..."
    exit 1
fi

# check that WEBUIPORT is set
if [ -z "$WEBUIPORT" ]
then
    echo "[error] WEBUIPORT not defined, exiting ..."
    exit 1
fi

# verify qbit config
if [ ! -f /root/.config/qBittorrent/qBittorrent.conf ]
then
    echo "[info] Config not found reverting to original."
    cp /default/qBittorrent.conf /root/.config/qBittorrent/qBittorrent.conf
fi

# check if BINDPORT is set
if [ ! -z "$BINDPORT" ]
then
    echo "[info] Overriding BINDPORT to ${BINDPORT}"
     sed -r -i "s/(PortRangeMin=)[^\"]+()/\1${BINDPORT}\2/" /root/.config/qBittorrent/qBittorrent.conf
fi

if [ -f /etc/wireguard/"$INTERFACE".conf ]
then
  chmod 600 /etc/wireguard/"$INTERFACE".conf
  wg-quick up "$INTERFACE"
fi

docker_interface="$(route | grep '^default' | awk '{print $8}')"
DEFAULT_GATEWAY="$(route | grep '^default' | awk '{print $2}')"

# split comma separated string into list from LAN_NETWORK env variable
IFS=',' read -ra lan_network_list <<< "${LAN_NETWORK}"

# add lannetworks
for lan_network_item in "${lan_network_list[@]}"; do
    # strip whitespace from start and end of lan_network_item
    lan_network_item=$(echo "${lan_network_item}" | sed -e 's~^[ \t]*~~;s~[ \t]*$~~')

    echo "[info] Adding ${lan_network_item} as route via ${DEFAULT_GATEWAY} dev ${docker_interface}"
    ip route add "${lan_network_item}" via "${DEFAULT_GATEWAY}" dev "${docker_interface}"
done

# start transmission
/usr/bin/qbittorrent-nox --webui-port=${WEBUIPORT}

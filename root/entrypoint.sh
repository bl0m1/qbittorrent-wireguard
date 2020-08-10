#!/bin/sh

INTERFACE="wg0"

# check for wireguard config, then start wireguard
if [ ! -f /etc/wireguard/"$INTERFACE".conf ]
then
  echo "Could not find /etc/wireguard/"$INTERFACE".conf"
fi

if [ -f /etc/wireguard/"$INTERFACE".conf ]
then
  chmod 600 /etc/wireguard/"$INTERFACE".conf
  wg-quick up "$INTERFACE"
fi

# start transmission
/usr/bin/qbittorrent-nox --webui-port=8080 --configuration=/config/qbittorent.conf

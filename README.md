# qbittorrent-wireguard

## Usage

```nbash
docker run -d --rm --cap-add net_admin --cap-add sys_module --privileged -p 8081:8081 -v qbit_wireguard:/etc/wireguard -e WEBUIPORT=8081 -e LAN_NETWORK="192.168.0.0/24" --name wgqb bl0m1/wireguard-qbittorrent
```

**NOTE: ** Your wireguard config needs to be placed in the volume "qbit_wireguard" and be called "wg0.conf"

## Envs:
* WEBUIPORT - used to change webui port
* BINDPORT - used for portforward
* LAN_NETWORK - IPs to bypass weiregyuards magic

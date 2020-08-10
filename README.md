# qbittorrent-wireguard

## Usage

```nbash
docker run -d --rm --cap-add net_admin --cap-add sys_module --privileged -p 8081:8081 -e WEBUIPORT=8080 -e LAN_NETWORK="192.168.0.0/24" --name wgqb bl0m1/wireguard-qbittorrent
```

## Envs:
* WEBUIPORT - used to change webui port
* BINDPORT - used for portforward
* LAN_NETWORK - IPs to bypass weiregyuards magic

#!/bin/sh

IP_APIS="
https://myip.ipip.net/s
https://ddns.oray.com/checkip
https://ip.3322.net
"

is_public_ipv4() {
    printf '%s\n' "$1" | awk -F. '
    NF != 4 { exit 1 }
    {
        for (i = 1; i <= 4; i++) {
            if ($i !~ /^[0-9]+$/ || $i < 0 || $i > 255) exit 1
        }
        if ($1 == 0 || $1 == 10 || $1 == 127) exit 1
        if ($1 == 100 && $2 >= 64 && $2 <= 127) exit 1
        if ($1 == 169 && $2 == 254) exit 1
        if ($1 == 172 && $2 >= 16 && $2 <= 31) exit 1
        if ($1 == 192 && ($2 == 0 || $2 == 2 || $2 == 168 || ($2 == 88 && $3 == 99))) exit 1
        if ($1 == 198 && ($2 == 18 || $2 == 19 || $2 == 51)) exit 1
        if ($1 == 203 && $2 == 0 && $3 == 113) exit 1
        if ($1 >= 224) exit 1
    }'
}

[ -x /etc/init.d/miniupnpd ] || exit 0
/etc/init.d/miniupnpd enabled >/dev/null 2>&1 || exit 0
[ "$(uci -q get upnpd.config.enabled)" = "1" ] || exit 0

for api in $IP_APIS; do
    public_ip=$(curl -4fs --max-time 8 "$api" | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | head -n 1)
    [ -n "$public_ip" ] && is_public_ipv4 "$public_ip" && break
    public_ip=
done

if [ -z "$public_ip" ]; then
    logger -t update-upnp -p err "Failed to detect public IPv4"
    exit 1
fi

if ! uci set upnpd.config.external_ip="$public_ip" ||
   ! uci commit upnpd ||
   ! /etc/init.d/miniupnpd restart; then
    logger -t update-upnp -p err "Failed to update miniupnpd external IP"
    exit 1
fi

logger -t update-upnp "Updated miniupnpd external IP to $public_ip"

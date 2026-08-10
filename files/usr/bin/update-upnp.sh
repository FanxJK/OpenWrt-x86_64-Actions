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
        exit 0
    }'
}

is_upnp_enabled() {
    [ -x /etc/init.d/miniupnpd ] || return 1
    /etc/init.d/miniupnpd enabled >/dev/null 2>&1 || return 1
    [ "$(uci -q get upnpd.config.enabled)" = "1" ] || return 1
}

get_public_ip() {
    if ! command -v curl >/dev/null 2>&1; then
        logger -t "update-upnp" -p err "curl is not installed"
        return 1
    fi

    for api in $IP_APIS; do
        logger -t "update-upnp" "Trying $api for public IP"

        ip=$(curl -4 -fsS --connect-timeout 5 --max-time 8 "$api" 2>/dev/null | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | head -n 1)

        if [ -n "$ip" ] && is_public_ipv4 "$ip"; then
            logger -t "update-upnp" "Detected public IP: $ip"
            printf '%s' "$ip"
            return 0
        fi

        if [ -n "$ip" ]; then
            logger -t "update-upnp" -p warning "Rejected non-public or invalid IPv4 from $api: $ip"
        fi
        logger -t "update-upnp" -p warning "Failed to get public IPv4 from $api"
    done

    logger -t "update-upnp" -p err "Failed to detect public IP from all APIs"
    return 1
}

update_upnpd_config() {
    ip="$1"

    if [ -z "$ip" ]; then
        logger -t "update-upnp" -p err "Public IP is empty"
        return 1
    fi

    if ! is_public_ipv4 "$ip"; then
        logger -t "update-upnp" -p err "Refusing invalid or non-public IPv4: $ip"
        return 1
    fi

    if ! uci set upnpd.config.external_ip="$ip"; then
        logger -t "update-upnp" -p err "Failed to update upnpd external_ip"
        return 1
    fi

    if ! uci commit upnpd; then
        logger -t "update-upnp" -p err "Failed to commit upnpd config"
        return 1
    fi

    if ! /etc/init.d/miniupnpd restart; then
        logger -t "update-upnp" -p err "Failed to restart miniupnpd"
        return 1
    fi

    logger -t "update-upnp" "Updated upnpd external IP to $ip"
    return 0
}

main() {
    if ! is_upnp_enabled; then
        logger -t "update-upnp" "miniupnpd is disabled; skipping external IP update"
        exit 0
    fi

    if ! public_ip=$(get_public_ip); then
        logger -t "update-upnp" -p err "Unable to detect public IP; aborting"
        exit 1
    fi

    if ! update_upnpd_config "$public_ip"; then
        logger -t "update-upnp" -p err "Unable to update upnpd config; aborting"
        exit 1
    fi

    logger -t "update-upnp" "miniupnpd external IP refresh completed: $public_ip"
    exit 0
}

main "$@"

#!/bin/sh

IP_APIS="
http://myip.ipip.net/s
http://ddns.oray.com/checkip
http://ip.3322.net
http://members.3322.org/dyndns/getip
"

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

        if [ -n "$ip" ]; then
            logger -t "update-upnp" "Detected public IP: $ip"
            printf '%s' "$ip"
            return 0
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

    old_ip="$(uci -q get upnpd.config.external_ip)"
    if [ "$old_ip" = "$ip" ]; then
        logger -t "update-upnp" "upnpd external IP unchanged: $ip"
        return 0
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

    public_ip=$(get_public_ip)
    if [ $? -ne 0 ]; then
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

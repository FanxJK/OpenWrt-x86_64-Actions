#!/bin/bash

declare -a IP_APIS=(
    "http://4.ipw.cn"
    "http://myip.ipip.net"
    "http://ip.3322.net"
    "http://members.3322.org/dyndns/getip"
)

get_public_ip() {
    local ip=""

    for api in "${IP_APIS[@]}"; do
        logger -t "update-upnp" "正在尝试从 $api 获取IP..."
        
        ip=$(curl -s --connect-timeout 5 "$api" | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | head -n 1)

        if [ $? -ne 0 ]; then
            logger -t "update-upnp" -p warning "警告: 从 $api 获取IP失败"
            continue
        fi

        if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            logger -t "update-upnp" "成功获取IP: $ip"
            printf "%s" "$ip"
            return 0
        else
            logger -t "update-upnp" -p warning "警告: 从 $api 获取的响应格式不正确"
        fi
    done
    
    logger -t "update-upnp" -p err "错误: 所有API尝试均失败"
    return 1
}

update_upnpd_config() {
    local ip="$1"
    if [ -z "$ip" ]; then
        logger -t "update-upnp" -p err "错误: IP 地址为空"
        return 1
    fi
    
    if ! uci set upnpd.config.external_ip="$ip"; then
        logger -t "update-upnp" -p err "错误: 无法更新 upnpd 配置"
        return 1
    fi
    
    if ! uci commit upnpd; then
        logger -t "update-upnp" -p err "错误: 无法提交 upnpd 配置更改"
        return 1
    fi
    
    if ! /etc/init.d/miniupnpd restart; then
        logger -t "update-upnp" -p err "错误: 无法重启 miniupnpd 服务"
        return 1
    fi
    
    logger -t "update-upnp" "成功更新并重启 upnpd 服务"
    return 0
}

main() {
    PUBLIC_IP=$(get_public_ip)
    
    if [ $? -ne 0 ]; then
        logger -t "update-upnp" -p err "错误: 无法获取公网IP, 退出程序"
        exit 1
    fi

    if ! update_upnpd_config "$PUBLIC_IP"; then
        logger -t "update-upnp" -p err "错误: 更新配置失败, 退出程序"
        exit 1
    fi
    
    logger -t "update-upnp" "成功更新 upnpd 配置, 当前公网IP: $PUBLIC_IP"
    exit 0
}

main
#!/bin/bash

# 获取公网IP并赋值给环境变量PUBLIC_IP
PUBLIC_IP=$(curl myip.ipip.net | sed -n 's/当前 IP：\([0-9\.]*\).*/\1/p')

# 使用获取到的IP地址设置upnpd的external_ip
uci set upnpd.config.external_ip="$PUBLIC_IP"
uci commit upnpd
/etc/init.d/miniupnpd restart
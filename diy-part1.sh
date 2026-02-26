#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Remove git revision
curl https://raw.githubusercontent.com/immortalwrt/immortalwrt/openwrt-24.10/feeds.conf.default -o feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
echo 'src-git fanx https://github.com/FanxJK/openwrt-packages' >> feeds.conf.default

# luci-app-easytier
git clone https://github.com/EasyTier/luci-app-easytier.git --depth=1 --single-branch package/luci-app-easytier

# luci-app-netspeedtest
git clone https://github.com/muink/luci-app-netspeedtest.git --depth=1 --single-branch package/luci-app-netspeedtest

# luci-app-bandix
git clone https://github.com/timsaya/luci-app-bandix.git --depth=1 --single-branch package/luci-app-bandix
git clone https://github.com/timsaya/openwrt-bandix.git --depth=1 --single-branch package/bandix

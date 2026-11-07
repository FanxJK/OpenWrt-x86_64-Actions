#!/bin/bash
set -e
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: custom-feeds.sh
# Description: Custom script before updating feeds
#

# Remove git revision
curl https://raw.githubusercontent.com/immortalwrt/immortalwrt/openwrt-25.12/feeds.conf.default -o feeds.conf.default

# Add custom package feed
echo 'src-git-full fanx https://github.com/FanxJK/openwrt-packages' >> feeds.conf.default

# luci-app-easytier
EASYTIER_TAG=$(curl -fsSL \
  -H "Authorization: Bearer $GH_TOKEN" \
  https://api.github.com/repos/EasyTier/luci-app-easytier/releases/latest |
  python3 -c 'import json,sys; print(json.load(sys.stdin)["tag_name"])')
[ -n "$EASYTIER_TAG" ] || { echo "Unable to resolve the latest EasyTier release tag."; exit 1; }
git clone --depth=1 --single-branch --branch "$EASYTIER_TAG" https://github.com/EasyTier/luci-app-easytier.git package/luci-app-easytier

# luci-app-netspeedtest
git clone --depth=1 --single-branch https://github.com/muink/luci-app-netspeedtest.git package/luci-app-netspeedtest

# luci-app-bandix-plus
git clone --depth=1 --single-branch https://github.com/timsaya/luci-app-bandix-plus.git package/luci-app-bandix-plus
git clone --depth=1 --single-branch https://github.com/timsaya/openwrt-bandix-plus.git package/openwrt-bandix-plus

# Vantage
git clone --depth=1 --single-branch https://github.com/anothaDev/luci-theme-vantage.git package/vantage
sh "$GITHUB_WORKSPACE/files/scripts/custom-vantage.sh" package/vantage/luci-theme-vantage
rm -rf "$GITHUB_WORKSPACE/files/scripts"

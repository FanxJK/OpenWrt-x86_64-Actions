#!/bin/bash
set -e
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: custom-config.sh
# Description: Custom script after installing feeds
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

# Replace stale luci-app-openclash from ImmortalWrt's release luci feed
# with the latest upstream OpenClash package. The sysupgrade keep scope is
# constrained separately by files/etc/uci-defaults/zzzz-openclash-sysupgrade-keep
# to avoid backing up large OpenClash runtime/cache files on x86.
tmp_openclash="$(mktemp -d)"
trap 'rm -rf "$tmp_openclash"' EXIT

git clone --depth=1 --filter=blob:none --sparse https://github.com/vernesong/OpenClash.git "$tmp_openclash"
git -C "$tmp_openclash" sparse-checkout set luci-app-openclash

rm -rf feeds/luci/applications/luci-app-openclash
mv "$tmp_openclash/luci-app-openclash" feeds/luci/applications/luci-app-openclash

# Disable downloading ci-llvm
# sed -i 's/--set=llvm\.download-ci-llvm=true/--set=llvm.download-ci-llvm=false/' feeds/packages/lang/rust/Makefile

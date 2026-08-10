#!/bin/bash
set -euo pipefail
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
feeds_tmp="$(mktemp "${TMPDIR:-/tmp}/feeds.conf.default.XXXXXX")"
trap 'rm -f "$feeds_tmp"' EXIT
curl -fsSL --retry 3 --retry-all-errors --retry-delay 2 \
  https://raw.githubusercontent.com/immortalwrt/immortalwrt/openwrt-25.12/feeds.conf.default \
  -o "$feeds_tmp"
mv "$feeds_tmp" feeds.conf.default
trap - EXIT

# Pin SmartDNS to Release48.4
SMARTDNS_VERSION="48.4"
SMARTDNS_SOURCE_HASH="b07abba99e921f262ba47588e12f5b36dd849f79c0145542440eb6b7eed80553"
SMARTDNS_RECIPE_COMMIT="69f474e5d5f764d0f6d4be9e0356f656cf375ba6"
SMARTDNS_PACKAGE_DIR="package/net/smartdns"

mkdir -p "$SMARTDNS_PACKAGE_DIR"
curl -fsSL --retry 3 --retry-all-errors --retry-delay 2 \
  "https://raw.githubusercontent.com/immortalwrt/packages/${SMARTDNS_RECIPE_COMMIT}/net/smartdns/Makefile" \
  -o "$SMARTDNS_PACKAGE_DIR/Makefile"

# shellcheck disable=SC2016
sed -i \
  -e "s/^PKG_VERSION:=.*/PKG_VERSION:=${SMARTDNS_VERSION}/" \
  -e 's/^PKG_RELEASE:=.*/PKG_RELEASE:=1/' \
  -e "s/^PKG_HASH:=.*/PKG_HASH:=${SMARTDNS_SOURCE_HASH}/" \
  -e 's/^  DEPENDS:=+i386:libatomic +libopenssl$/  DEPENDS:=+i386:libatomic +libopenssl +zlib/' \
  -e 's|^include ../../lang/rust/rust-package.mk$|include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk|' \
  "$SMARTDNS_PACKAGE_DIR/Makefile"

grep -qxF "PKG_VERSION:=${SMARTDNS_VERSION}" "$SMARTDNS_PACKAGE_DIR/Makefile"
grep -qxF "PKG_HASH:=${SMARTDNS_SOURCE_HASH}" "$SMARTDNS_PACKAGE_DIR/Makefile"
grep -qxF '  DEPENDS:=+i386:libatomic +libopenssl +zlib' "$SMARTDNS_PACKAGE_DIR/Makefile"
# shellcheck disable=SC2016
grep -qxF 'include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk' "$SMARTDNS_PACKAGE_DIR/Makefile"

# Add custom package feed
FANX_FEED='src-git fanx https://github.com/FanxJK/openwrt-packages'
grep -qxF "$FANX_FEED" feeds.conf.default || printf '%s\n' "$FANX_FEED" >> feeds.conf.default

# luci-app-easytier
git clone --depth=1 --single-branch https://github.com/EasyTier/luci-app-easytier.git package/luci-app-easytier

# luci-app-netspeedtest
git clone --depth=1 --single-branch https://github.com/muink/luci-app-netspeedtest.git package/luci-app-netspeedtest

# luci-app-bandix-plus
git clone --depth=1 --single-branch https://github.com/timsaya/luci-app-bandix-plus.git package/luci-app-bandix-plus
git clone --depth=1 --single-branch https://github.com/timsaya/openwrt-bandix-plus.git package/openwrt-bandix-plus

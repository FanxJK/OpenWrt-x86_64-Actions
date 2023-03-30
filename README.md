# OpenWrt-x86_64-Actions

基于 Lean 源码的自用项目，每周自动编译和构建。  
基于 [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt) 修改，去除了已弃用或即将弃用的库和环境，解决 Actions WARNING 问题  
感谢 [P3TERX](https://github.com/P3TERX) 与 [coolsnowwolf](https://github.com/coolsnowwolf)

软件包:
- `luci-app-wolplus`
- `luci-app-openclash`
- `luci-app-uugamebooster`
- `luci-app-turboacc` (使用 Linux 原生的 Flow Offloading, 没有使用 Shortcut FE, 避免全锥型 NAT 失效)
- `luci-theme-argon`
- `open-vm-tools-fuse`
- `msd_lite`

只编译了极简的 OpenWrt 系统，仅包含必要的软件包和应用程序，以确保系统稳定和流畅。

## 下载

您可以在项目的 [Release 页面](https://github.com/FanxJK/OpenWrt-x86_64-Actions/releases) 下载最新版本的固件

以下是对每个文件的说明：
- `config.buildinfo` 用于构建 OpenWrt 固件的配置信息，包括选定的软件包、编译选项等
- `feeds.buildinfo` 构建固件时使用的 OpenWrt feeds 的版本和信息
- `openwrt-x86-64-generic-kernel.bin` OpenWrt 固件的内核镜像文件
- `openwrt-x86-64-generic-squashfs-combined-efi.img.gz` 用于在 UEFI 系统上安装 OpenWrt
- `openwrt-x86-64-generic-squashfs-rootfs.img.gz` rootfs 镜像文件，通常用于 Docker 或 LXC 等容器
- `openwrt-x86-64-generic.manifest` 构建 OpenWrt 固件时使用的软件包和版本信息


## 更新时间

会在每周的 UTC 时间周五 01:00 自动编译并更新

## 免责声明

请注意，该项目仅用于个人学习和测试，不建议用于生产环境。在使用前，请确保您已经了解相关知识，并且具备足够的技术能力。任何因为使用该项目而导致的问题，作者概不负责。

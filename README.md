# OpenWrt-x86_64-Actions

基于 ImmortalWrt 源码的自用项目，每周自动编译和构建。  
基于 [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt) 修改，去除了已弃用或即将弃用的库和环境，解决 Actions WARNING 问题  
感谢 [P3TERX](https://github.com/P3TERX) 与 [ImmortalWrt](https://github.com/immortalwrt)

# Changelog
## 2023-06-26
- 编译时间修改为随上游稳定版发布更新

## 2023-06-24
- 切换到 `ImmortalWrt 21.02` 源码，之前版本请全新安装

# 说明
软件包:
- `luci-app-mosdns`
- `luci-app-wolplus`
- `luci-app-openclash`
- `luci-app-uugamebooster`
- `luci-app-turboacc` (使用 Linux 原生的 Flow Offloading, 没有使用 Shortcut FE, 避免全锥型 NAT 失效)
- `luci-app-iptvhelper`
- `luci-app-msd_lite`
- `luci-app-upnp`
- `qemu-ga`
- `nginx`
- `msd_lite`

只编译了极简的 OpenWrt 系统，仅包含必要的软件包和应用程序，以确保系统稳定和流畅。

## 下载

您可以在项目的 [Releases 页面](https://github.com/FanxJK/OpenWrt-x86_64-Actions/releases) 下载最新版本的固件

以下是对每个文件的说明：
- `config.buildinfo` 用于构建 OpenWrt 固件的配置信息，包括选定的软件包、编译选项等
- `feeds.buildinfo` 构建固件时使用的 OpenWrt feeds 的版本和信息
- `immortalwrt-x86-64-generic-kernel.bin` OpenWrt 固件的内核镜像文件
- `immortalwrt-x86-64-generic-rootfs.tar.gz` rootfs 归档文件，包含 OpenWrt 固件的根文件系统
- `immortalwrt-x86-64-generic-squashfs-combined-efi.img.gz` 用于在 UEFI 系统上安装 OpenWrt
- `immortalwrt-x86-64-generic-squashfs-combined-efi.qcow2` 用于在 Proxmox VE 上安装 OpenWrt
- `immortalwrt-x86-64-generic-squashfs-rootfs.img.gz` rootfs 镜像文件，通常用于 Docker 或 LXC 等容器
- `immortalwrt-x86-64-generic.manifest` 构建 OpenWrt 固件时使用的软件包和版本信息


## 更新时间

每天的 UTC 时间周五 01:23 自动检查 [Tags](https://github.com/immortalwrt/immortalwrt/tags) 更新并编译上传到 [Releases](https://github.com/FanxJK/OpenWrt-x86_64-Actions/releases)  
> 只编译 Release 版，不编译 RC 版  

本项目的[Tags](https://github.com/FanxJK/OpenWrt-x86_64-Actions/tags) 为北京时间

## 免责声明

请注意，该项目仅用于个人学习和测试，不建议用于生产环境。在使用前，请确保您已经了解相关知识，并且具备足够的技术能力。任何因为使用该项目而导致的问题，作者概不负责。

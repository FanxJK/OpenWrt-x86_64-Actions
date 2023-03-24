# OpenWrt-x86_64-Actions

基于 Lean 源码的自用项目，每周自动编译和构建。

软件包:
- `luci-app-wolplus`
- `luci-app-openclash`
- `luci-app-uugamebooster`
- `luci-app-turboacc` (使用 Linux 原生的 Flow Offloading 避免 Shortcut FE 导致的全锥型 NAT 失效)
- `luci-theme-argon`
- `open-vm-tools-fuse`
- `msd_lite`

只编译了极简的 OpenWrt 系统，仅包含必要的软件包和应用程序，以确保系统稳定和流畅。

## 下载

您可以在项目的 [Release 页面](https://github.com/FanxJK/OpenWrt-x86_64-Actions/releases) 下载最新版本的固件进行刷写。

## 更新时间

会在每周的北京时间周五 01:00 自动编译并更新。

## 免责声明

请注意，该项目仅用于个人学习和测试，不建议用于生产环境。在使用前，请确保您已经了解相关知识，并且具备足够的技术能力。任何因为使用该项目而导致的问题，作者概不负责。

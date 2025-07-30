# 自用测试固件，请勿下载

基于 ImmortalWrt 源码的自用项目，每周自动编译和构建。  
基于 [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt) 修改，去除已弃用或即将弃用的库和环境并解决 Actions WARNING 问题  
感谢 [P3TERX](https://github.com/P3TERX) 与 [ImmortalWrt](https://github.com/immortalwrt)

## 文件
- `config.buildinfo` 用于构建 OpenWrt 固件的配置信息，包括选定的软件包、编译选项等
- `feeds.buildinfo` 构建固件时使用的 OpenWrt feeds 的版本和信息
- `immortalwrt-x86-64-generic-kernel.bin` OpenWrt 固件的内核镜像文件
- `immortalwrt-x86-64-generic-rootfs.tar.gz` rootfs 归档文件，包含 OpenWrt 固件的根文件系统
- `immortalwrt-x86-64-generic-squashfs-combined-efi.img.gz` 用于在 UEFI 系统上安装 OpenWrt
- `immortalwrt-x86-64-generic-squashfs-combined-efi.qcow2` 用于在 Proxmox VE 上安装 OpenWrt (EFI 引导)
- `immortalwrt-x86-64-generic-squashfs-combined.img.gz` 用于在传统 BIOS 系统上安装 OpenWrt
- `immortalwrt-x86-64-generic-squashfs-combined.qcow2` 用于在 Proxmox VE 上安装 OpenWrt (传统 BIOS 引导)
- `immortalwrt-x86-64-generic-squashfs-rootfs.img.gz` rootfs 镜像文件，通常用于 Docker 或 LXC 等容器
- `immortalwrt-x86-64-generic.manifest` 构建 OpenWrt 固件时使用的软件包和版本信息

# 请注意，该项目仅用于个人学习和测试，请不要下载使用。

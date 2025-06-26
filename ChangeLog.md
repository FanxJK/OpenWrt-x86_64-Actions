# 2025-06-26
- 新增 `luci-app-cloudflared`
- 更新 ImmortalWrt 版本到 24.10.2

# 2025-06-10
- 新增 `FakeHTTP`

# 2025-05-22
- 更新 ImmortalWrt 版本到 24.10.1
- 修复 NAT 环境下的 UPnP 有时不生效的问题
- 更新 UU 加速器和 EasyTier 的版本
- 优化 OTA 更新流程，可显示 ChangeLog 和下载进度

# 2025-02-07
- 新增 `easytier` 软件包

# 2025-01-13
- 修复 NAT 环境下的 UPnP

# 2024-12-31
- OpenClash 的不自动关闭连接问题上游已解决

# 2024-12-19
- 新增 `luci-app-easytier`
- 临时修复 OpenClash 的不自动关闭连接问题

# 2024-12-11
- 更新 ImmortalWrt 版本到 24.10

# 2024-11-12
- 新增 `pppoe-discovery`

# 2024-07-25
- 新增 `luci-app-natmap`

# 2024-06-25
- 新增 `luci-app-zerotier`
- 去除 SmartDNS 的版本固定，使用最新版

# 2024-05-15
- 将 Nginx 切换回默认的 uHTTPd

# 2024-03-26
- 暂时降级 SmartDNS 至 Release 43，解决国际域名解析问题

# 2024-01-30
- 删除 MosDNS

# 2024-01-16
- 新增 luci-app-fileassistant

# 2023-11-29
- 新增 SmartDNS

# 2023-11-06
- 新增 SFTP 支持

# 2023-07-20
- 更新 ImmortalWrt 版本到 23.05
- 去除 `BBR`
- 去除 `Turbo ACC`
- 默认防火墙现已切换到 `nftables`
- 防火墙现已默认支持 `FullCone NAT`、`FullCone NAT6`

# 2023-06-27
- 加入 OTA 功能

# 2023-06-26
- 编译时间修改为随上游稳定版发布更新 (版本固定在 21.02)

# 2023-06-24
- 切换到 `ImmortalWrt 21.02` 源码，之前版本请全新安装

#!/bin/bash

# 定义变量
SNELL_URL="https://dl.nssurge.com/snell/snell-server-v5.0.0b3-linux-amd64.zip"
SNELL_DIR="/usr/local/bin"
SNELL_BIN="${SNELL_DIR}/snell-server"
SNELL_ZIP="snell-server.zip"
TMP_DIR="/tmp/snell_update"

# 检查是否为 root 用户
if [ "$(id -u)" -ne 0 ]; then
  echo "请以 root 权限运行此脚本！"
  exit 1
fi

# 创建临时目录
mkdir -p "$TMP_DIR"
cd "$TMP_DIR" || exit 1

# 停止 Snell 服务
echo "停止 Snell 服务..."
systemctl stop snell

# 下载新版本
echo "下载新版本 Snell..."
wget -O "$SNELL_ZIP" "$SNELL_URL"
if [ $? -ne 0 ]; then
  echo "下载失败，请检查网络连接。"
  exit 1
fi

# 解压新版本
echo "解压 Snell..."
unzip -o "$SNELL_ZIP"
if [ $? -ne 0 ]; then
  echo "解压失败，请确认 ZIP 文件是否有效。"
  exit 1
fi

# 替换可执行文件
echo "替换 Snell 执行文件..."
chmod +x snell-server
mv -f snell-server "$SNELL_BIN"

# 重启 Snell 服务
echo "启动 Snell 服务..."
systemctl start snell

# 检查服务状态
echo "检查 Snell 服务状态..."
systemctl status snell --no-pager

# 清理临时文件
echo "清理临时文件..."
rm -rf "$TMP_DIR"

echo "Snell 更新完成！"

#!/bin/bash
set -e

OPENWRT_IMAGE="/opt/images/openwrt.tar.gz"
CONTAINER_NAME="openwrt-router"
IMAGE_ALIAS="openwrt-img"

# ⬇️ パススルーしたい物理NICのインターフェイス名
PHY_NIC_WAN="eth1"
PHY_NIC_LAN="eth2"

echo "LXD Router Setup: Starting..."

# snapdが完全に準備できるのを待つ
echo "Waiting for snapd to be ready..."
snap wait system seed.loaded

# LXDをインストール
echo "Installing/Refreshing LXD snap..."
snap install lxd

# LXDデーモンが起動するのを待つ
echo "Waiting for LXD daemon..."
while ! lxd ready; do
    echo "Waiting..."
    sleep 2
done

# LXDを初期化
echo "Initializing LXD..."
lxd init --auto

# 1. イメージのインポート
if [ -f "$OPENWRT_IMAGE" ]; then
    if ! lxc image info "$IMAGE_ALIAS" > /dev/null 2>&1; then
        echo "Importing OpenWrt image from $OPENWRT_IMAGE..."
        lxc import "$OPENWRT_IMAGE" --alias "$IMAGE_ALIAS"
    else
        echo "OpenWrt image already imported."
    fi
else
    echo "ERROR: OpenWrt image not found at $OPENWRT_IMAGE"
    exit 1
fi

## # 2. コンテナの作成 (まだ起動しない)
## if ! lxc info "$CONTAINER_NAME" > /dev/null 2>&1; then
##     echo "Creating $CONTAINER_NAME container (init)..."
##     ## lxc init "$IMAGE_ALIAS" "$CONTAINER_NAME"
## 
##     ## # 3. NICのパススルー設定
##     ## echo "Configuring NIC pass-through..."
##     ## # WAN
##     ## lxc config device add "$CONTAINER_NAME" "$PHY_NIC_WAN" nic nictype=physical parent="$PHY_NIC_WAN"
##     ## # LAN
##     ## lxc config device add "$CONTAINER_NAME" "$PHY_NIC_LAN" nic nictype=physical parent="$PHY_NIC_LAN"
## 
##     ## # 4. コンテナの起動
##     ## echo "Starting container..."
##     ## lxc start "$CONTAINER_NAME"
##     ## echo "Container created, configured, and started."
## else
##     echo "Container $CONTAINER_NAME already exists. Ensuring it is started."
##     lxc start "$CONTAINER_NAME"
## fi

echo "LXD Router Setup: Complete."

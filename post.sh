#!/bin/bash
set -eux

# ユーザーのホームに設定
HOME_DIR="/home/rlynick"
mkdir -p "$HOME_DIR"

# fish をデフォルトシェルに設定
chsh -s /usr/bin/fish rlynick

# パスワード無効化
passwd -d rlynick

# sudo 権限付与
echo "rlynick ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/rlynick

# systemd ユニット有効化
systemctl enable NetworkManager
systemctl enable seatd

# XDGディレクトリ更新
runuser -l rlynick -c "xdg-user-dirs-update"

# Niriを自動起動する場合 (オプション)
mkdir -p "$HOME_DIR/.config/systemd/user"
cat > "$HOME_DIR/.config/systemd/user/niri.service" <<'EOF'
[Unit]
Description=Niri compositor
After=graphical-session.target

[Service]
ExecStart=/usr/bin/niri
Restart=on-failure

[Install]
WantedBy=default.target
EOF
chown -R rlynick:rlynick "$HOME_DIR/.config"


#!/usr/bin/env bash

TARGET_DIR="$HOME/.everything_is_soup"
mkdir -p "$TARGET_DIR/plugins"

echo "[+] Installing soup-kitchen..."
curl -sSL "raw.githubusercontent.com/gabrielbindi/everything_is_soup.git/main/soup.config" -o "$TARGET_DIR/soup.config"
curl -sSL "raw.githubusercontent.com/gabrielbindi/everything_is_soup.git/main/plugins/lazygit.sh" -o "$TARGET_DIR/plugins/lazygit.sh"

if ! grep -q "soup.config" "$HOME/.bashrc"; then
    echo "[+] Configuring soup-kitchen as your shell environment..."

    echo -e "\n# soup-kitchen auto-start\nexec bash --rcfile $TARGET_DIR/soup.config" >> "$HOME/.bashrc"
fi

echo "[+] Installation complete. Please restart your terminal or run 'source ~/.bashrc' to apply the changes."


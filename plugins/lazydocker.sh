SOUP_DIR="$SOUP_CORE_DIR"

command mkdir -p "$SOUP_DIR/plugins/lazydocker"

if command -v lazydocker &> /dev/null; then
    command echo -e "\033[1;32m[+] lazydocker is already installed.\033[0m"

    THEME_FILE="$SOUP_DIR/plugins/lazydocker/.lazydocker_theme.yml"
    if [ ! -f "$THEME_FILE" ]; then
        command cat << 'EOF' > "$THEME_FILE"

gui:
  theme:
    activeBorderColor:
      - "#FF0000"
      - "bold"
    inactiveBorderColor:
      - "#FFFF00"
    optionsTextColor:
      - "#00FFFF"
    selectedLineBgColor:
      - "#FFFF00"
      - "reverse"
      - "bold"

EOF
fi

alias soup-docker="DIR='$SOUP_DIR/plugins/lazydocker' lazydocker"

else
    command echo -e "\033[1;31m[!] Ups, whalesoup is not installed. Type 'cook-whale', to add it to your kitchen.\033[0m"

    cook-whale() {
        command echo -e "\033[1;36m[+] Brewing up whalesoup...\033[0m"

        if command -v apt-get &> /dev/null; then
            command echo "packagemanager 'apt' detected. Brewing whalesoup via apt-get..."
            if command sudo apt-get update && command sudo apt-get install -y lazydocker 2>/dev/null; then
               INSTALL_STATUS=0
            else
            command echo -e "\033[1;33m[!] 'lazydocker' not in apt. Downloading stable x86_64 binary directly...\033[0m"
            command curl -sSL "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_Linux_x86_64.tar.gz" -o "$SOUP_DIR/plugins/lazydocker/lazydocker.tar.gz"
            command sudo tar -xzf "$SOUP_DIR/plugins/lazydocker/lazydocker.tar.gz" -C /usr/local/bin/
                INSTALL_STATUS=$?
            command rm -f "$SOUP_DIR/plugins/lazydocker/lazydocker.tar.gz"
            fi

        elif command -v pacman &> /dev/null; then
            command echo "packagemanager 'pacman' detected. Brewing whalesoup via pacman..."
            command sudo pacman -S --noconfirm lazydocker
            INSTALL_STATUS=$?

        elif command -v dnf &> /dev/null; then
            command echo "packagemanager 'dnf' detected. Brewing whalesoup via dnf..."
            command sudo dnf install -y lazydocker
            INSTALL_STATUS=$?

        else
            command echo -e "\033[1;31m[!] No supported package manager found. Please install lazydocker manually.\033[0m"
            return 1
        fi

        if [ $INSTALL_STATUS -eq 0 ]; then
            command echo -e "\033[1;32m[+] lazydocker has been successfully brewed!\033[0m"
            command echo -e "\033[1;36m[+] Restart your terminal or type 'source ~/.bashrc' to activate 'soup-docker'.\033[0m"
        else
            command echo -e "\033[1;31m[!] Failed to brew lazydocker. Please check your package manager and try again.\033[0m"
        fi
    }

    alias soup-docker="command echo 'whalesoup is not installed. Type \033[1;36mcook-whale\033[0m to brew it in your kitchen.'"
fi
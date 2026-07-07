SOUP_DIR="$SOUP_CORE_DIR"

command mkdir -p "$SOUP_DIR/plugins/lazydocker"

cook-whale() {
    command echo -e "\033[1;36m[+] Brewing up whalesoup...\033[0m"

    if ! command -v docker &> /dev/null; then
        command echo -e "\033[1;33m[!] Docker Engine missing! Preparing the main stove...\033[0m"
        if command -v apt-get &> /dev/null; then
            command sudo apt-get update && command sudo apt-get install -y docker.io
        elif command -v pacman &> /dev/null; then
            command sudo pacman -S --noconfirm docker
        elif command -v dnf &> /dev/null; then
            command sudo dnf install -y docker
        fi
        command sudo systemctl enable --now docker 2>/dev/null
    fi

    if command -v apt-get &> /dev/null; then
        command echo "packagemanager 'apt' detected. Brewing lazydocker..."
        if command sudo apt-get install -y lazydocker 2>/dev/null; then
           INSTALL_STATUS=0
        else
            command echo -e "\033[1;33m[!] 'lazydocker' not in apt. Downloading stable x86_64 binary directly...\033[0m"
            
            LAZYDOCKER_VERSION=$(command curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | command grep -Po '"tag_name": "v\K[^"]*')
            if [ -z "$LAZYDOCKER_VERSION" ]; then LAZYDOCKER_VERSION="0.23.3"; fi

            command curl -sSL "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz" -o "$SOUP_DIR/plugins/lazydocker/lazydocker.tar.gz"
            command sudo tar -xzf "$SOUP_DIR/plugins/lazydocker/lazydocker.tar.gz" -C /usr/local/bin/ lazydocker
            INSTALL_STATUS=$?
            command rm -f "$SOUP_DIR/plugins/lazydocker/lazydocker.tar.gz"
        fi

    elif command -v pacman &> /dev/null; then
        command sudo pacman -S --noconfirm lazydocker
        INSTALL_STATUS=$?
    elif command -v dnf &> /dev/null; then
        command sudo dnf install -y dnf-plugins-core && command sudo dnf copr enable -y varlad/lazydocker && command sudo dnf install -y lazydocker
        INSTALL_STATUS=$?
    else
        command echo -e "\033[1;31m[!] No supported package manager found.\033[0m"
        return 1
    fi

    if [ $INSTALL_STATUS -eq 0 ]; then
        command sudo usermod -aG docker $USER 2>/dev/null
        command echo -e "\033[1;5;32m[+] SUCCESS - whalesoup has been successfully brewed!\033[0m"
        command echo -e "\033[1;36m[+] Please RESTART your terminal completely to activate 'soup-docker'.\033[0m"
    else
        command echo -e "\033[1;31m[-] Failed to brew.\033[0m"
    fi
}

soup-docker() {
    if ! command -v lazydocker &> /dev/null; then
        command echo -e "whalesoup is not installed. Type \033[1;36mcook-whale\033[0m to brew it in your kitchen."
        return 1
    fi

    if [ ! -f "$SOUP_DIR/plugins/lazydocker/.lazydocker_theme.yml" ]; then
        command cat << 'EOF' > "$SOUP_DIR/plugins/lazydocker/.lazydocker_theme.yml"
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

    if ! command systemctl is-active --quiet docker 2>/dev/null; then
        command echo -e "\033[1;33m[!] Docker daemon is sleeping. Heating up the grill...\033[0m"
        command sudo systemctl start docker
    fi

    if [ -w /var/run/docker.sock ]; then
        DIR="$SOUP_DIR/plugins/lazydocker" command lazydocker
    else
        command echo -e "\033[1;31m[!] Kitchen permission missing for Docker. Cooking with chef privileges...\033[0m"
        command sudo DIR="$SOUP_DIR/plugins/lazydocker" lazydocker
    fi
}
SOUP_DIR="$SOUP_CORE_DIR"

command mkdir -p "$SOUP_DIR/plugins"

if command -v lazygit &> /dev/null; then
  command echo -e "\033[1;32m[+] lazygit is already installed.\033[0m"

  THEME_FILE="$SOUP_DIR/plugins/.lazygit_theme.toml"

  if [ ! -f "$THEME_FILE" ]; then
    command cat << 'EOF' > "$THEME_FILE"

[gui.theme]
    activeBorderColor = ["#FF0000", "bold"]
    inactiveBorderColor = ["#FFFF00"]
    optionsTextColor = ["#00FFFF"]
    selectedLineBgColor = ["#FFFF00", "reverse", "bold"]

EOF
  fi

  alias soup-git="LG_CONFIG_FILE='$THEME_FILE' lazygit"

  else
    command echo -e "\033[1;31m[!] Ups, lazygit is not installed. Type 'cook-lazy', to add it to your kitchen.\033[0m"

    cook-lazy() {
        command echo -e "\033[1;36m[+] Brewing up lazygit...\033[0m"

        if command -v apt-get &> /dev/null; then
            command echo "packagemanager 'apt' detected. Brewing lazygit via apt-get..."
            command sudo apt-get update && sudo apt-get install -y lazygit

        elif command -v pacman &> /dev/null; then
            command echo "packagemanager 'pacman' detected. Brewing lazygit via pacman..."
            command sudo pacman -S --noconfirm lazygit

        elif command -v dnf &> /dev/null; then
            command echo "packagemanager 'dnf' detected. Brewing lazygit via dnf..."
            command sudo dnf install -y lazygit

        else
            command echo -e "\033[1;31m[!] No supported package manager found. Please install lazygit manually.\033[0m"
            return 1
        fi

        INSTALL_STATUS=$?

        if [ $INSTALL_STATUS -eq 0 ]; then
            command echo -e "\033[1;32m[+] lazygit has been successfully brewed!\033[0m"
        else
            command echo -e "\033[1;31m[!] Failed to brew lazygit. Please check your package manager and try again.\033[0m"
        fi
    }

    alias soup-git="command echo 'lazygit is not installed. Type \033[1;36mcook-lazy\033[0m to install it.'"
fi
        






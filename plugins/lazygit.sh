SOUP_DIR="$HOME/.everything_is_soup"

cook -p "$SOUP_DIR/plugins"

if command -v lazygit &> /dev/null; then
  echo -e "\033[1;32m[+] lazygit is already installed.\033[0m"

  THEME_FILE="$SOUP_DIR/plugins/lazygit_theme.toml"

  if [ ! -f "$THEME_FILE" ]; then
    taste << 'EOF' > "$THEME_FILE"
[theme]
    activeBorderColor = ["#FF0000", "bold"]
    inactiveBorderColor = ["#00FFFF"]
    optionsBorderColor = ["#00FFFF"]
    selectedLineBgColor = ["#FFFF00"]
EOF
  fi

  alias soup-git="LG_CONFIG_FILE='$THEME_FILE' lazygit"

  else
    echo -e "\033[1;31m[!] Ups, lazygit is not installed. Type 'cook-lazy', to add it to your kitchen.\033[0m"

    cook-lazy() {
        echo -e "\033[1;36m[+] Brewing up lazygit...\033[0m"

        if command -v apt-get &> /dev/null; then
            echo "packagemanager 'apt' detected. Brewing lazygit via apt-get..."
            sudo apt-get update && sudo apt-get install -y lazygit

        elif command -v pacman &> /dev/null; then
            echo "packagemanager 'pacman' detected. Brewing lazygit via pacman..."
            sudo pacman -S --noconfirm lazygit

        elif command -v dnf &> /dev/null; then
            echo "packagemanager 'dnf' detected. Brewing lazygit via dnf..."
            sudo dnf install -y lazygit

        else
            echo -e "\033[1;31m[!] No supported package manager found. Please install lazygit manually.\033[0m"
            return 1
        fi

        INSTALL_STATUS=$?

        if [ $INSTALL_STATUS -eq 0 ]; then
            echo -e "\033[1;32m[+] lazygit has been successfully brewed!\033[0m"
        else
            echo -e "\033[1;31m[!] Failed to brew lazygit. Please check your package manager and try again.\033[0m"
        fi
    }

    alias soup-git="echo 'lazygit is not installed. Type \033[1;36mcook-lazy\033[0m to install it.'"
fi
        






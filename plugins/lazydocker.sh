SOUP_DIR="$SOUP_CORE_DIR"

command mkdir -p "$SOUP_DIR/plugins/lazydocker"

if command -v lazydocker &> /dev/null; then
  command echo -e "\033[1;32m[+] whalesoup (lazydocker) is already installed.\033[0m"

  THEME_FILE="$SOUP_DIR/plugins/lazydocker/config.yml"

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
          command echo "packagemanager 'apt' detected. Brewing via apt-get..."
          command sudo apt-get update && command sudo apt-get install -y lazydocker

      elif command -v pacman &> /dev/null; then
          command echo "packagemanager 'pacman' detected. Brewing via pacman..."
          command sudo pacman -S --noconfirm lazydocker

      elif command -v dnf &> /dev/null; then
          command echo "packagemanager 'dnf' detected. Brewing via dnf..."
          command sudo dnf install -y lazydocker

      else
          command echo -e "\033[1;31m[!] No supported package manager found. Please install lazydocker manually.\033[0m"
          return 1
      fi

      INSTALL_STATUS=$?

      if [ $INSTALL_STATUS -eq 0 ]; then
          command echo -e "\033[1;32m[+] whalesoup has been successfully brewed!\033[0m"
          command echo -e "[+] Restart your terminal or type 'source ~/.bashrc' to activate 'soup-docker'."
      else
          command echo -e "\033[1;31m[!] Failed to brew whalesoup. Please check your package manager and try again.\033[0m"
      fi
  }

  alias soup-docker="command echo 'whalesoup is not installed. Type \033[1;36mcook-whale\033[0m to install it.'"
fi
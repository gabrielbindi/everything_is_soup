SOUP_DIR="$HOME/.everything_is_soup"

mkdir -p "$SOUP_DIR/plugins"

if command -v lazygit &> /dev/null; then
  echo "lazygit is already installed."

  THEME_FILE="$SOUP_DIR/plugins/lazygit_theme.toml"

  if [ ! -f "$THEME_FILE" ]; then
    cat << 'EOF' > "$THEME_FILE"
[theme]
    activeBorderColor = ["#FF0000", "bold"]
    inactiveBorderColor = ["#00FFFF"]
    optionsBorderColor = ["#00FFFF"]
    selectedLineBgColor = ["#FFFF00"]
EOF
  fi

  alias soup-git="LG_CONFIG_FILE='$THEME_FILE' lazygit"

fi






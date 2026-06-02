#!/bin/bash
DOTS_DIR="$HOME/Documentos/repos/configs"
CONFIG_DIR="$HOME/.config"
packages=(
"alacritty"
"bc"
"brightnessctl"
"clamav"
"cliphist"
"firefox"
"gammastep"
"gimp"
"less"
"libnotify"
"man-db"
"mpv"
"niri"
"openssh"
"quickshell"
"rofi"
"swayidle"
"swaylock"
"ttf-jetbrains-mono-nerd"
"unzip"
"upower"
"which"
"xdg-desktop-portal-wlr"
"xwayland-satellite"
"zip"
)
echo "Solicitando privilégios para verificar/instalar pacotes..."
sudo pacman -S --needed "${packages[@]}"
echo "--------------------------------------------------"
if [ ! -d "$DOTS_DIR" ]; then
echo "Erro: Pasta $DOTS_DIR não encontrada. Verifique o caminho do clone."
exit 1
fi
mkdir -p "$CONFIG_DIR"
folders=("alacritty" "mpv" "niri" "nvim" "quickshell" "rofi" "scripts" "swaylock")
for folder in "${folders[@]}"; do
ln -sfn "$DOTS_DIR/$folder" "$CONFIG_DIR/$folder"
done
ln -sfn "$DOTS_DIR/mimeapps.list" "$CONFIG_DIR/mimeapps.list"
ln -sfn "$DOTS_DIR/.bashrc" "$HOME/.bashrc"
echo "Links simbólicos criados com sucesso!"

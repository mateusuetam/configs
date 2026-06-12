#!/bin/bash
DOTS_DIR="$HOME/Documentos/repos/configs"
CONFIG_DIR="$HOME/.config"
packages=(
"alacritty"
"bc"
"brightnessctl"
"cliphist"
"docker"
"firefox"
"gammastep"
"gimp"
"gnome-keyring"
"jdk-openjdk"
"less"
"libnotify"
"man-db"
"mpv"
"mysql-workbench"
"niri"
"openssh"
"otf-monaspace-nerdfonts"
"prismlauncher"
"qtcreator"
"quickshell"
"steam"
"unzip"
"upower"
"which"
"xwayland-satellite"
"zip"
)
echo "Privilégios para instalar pacotes..."
sudo pacman -S --needed "${packages[@]}"
echo "--------------------------------------------------"
if [ ! -d "$DOTS_DIR" ]; then
echo "Erro: Pasta $DOTS_DIR não encontrada. Verifique o caminho do clone."
exit 1
fi
mkdir -p "$CONFIG_DIR"
folders=("alacritty" "mpv" "niri" "nvim" "quickshell" "rofi" "scripts")
for folder in "${folders[@]}"; do
ln -sfn "$DOTS_DIR/$folder" "$CONFIG_DIR/$folder"
done
ln -sfn "$DOTS_DIR/mimeapps.list" "$CONFIG_DIR/mimeapps.list"
ln -sfn "$DOTS_DIR/.bashrc" "$HOME/.bashrc"
echo "Links simbólicos criados com sucesso!"
echo "--------------------------------------------------"
echo "Configurando plugins do Neovim..."
START_PLUGINS_DIR="$DOTS_DIR/nvim/pack/plugins/start"
OPT_PLUGINS_DIR="$DOTS_DIR/nvim/pack/plugins/opt"
mkdir -p "$START_PLUGINS_DIR"
mkdir -p "$OPT_PLUGINS_DIR"
if [ ! -d "$START_PLUGINS_DIR/alpha-nvim" ]; then
echo "Clonando alpha-nvim..."
git clone https://github.com/goolord/alpha-nvim.git "$START_PLUGINS_DIR/alpha-nvim"
else
echo "Alpha-nvim já está instalado."
fi
if [ ! -d "$OPT_PLUGINS_DIR/telescope.nvim" ]; then
echo "Clonando telescope.nvim..."
git clone https://github.com/nvim-telescope/telescope.nvim.git "$OPT_PLUGINS_DIR/telescope.nvim"
else
echo "Telescope já está instalado."
fi
if [ ! -d "$OPT_PLUGINS_DIR/plenary.nvim" ]; then
echo "Clonando plenary.nvim..."
git clone https://github.com/nvim-lua/plenary.nvim.git "$OPT_PLUGINS_DIR/plenary.nvim"
else
echo "Plenary já está instalado."
fi
echo "--------------------------------------------------"
echo "Instalação do ambiente de trabalho concluída com sucesso!"

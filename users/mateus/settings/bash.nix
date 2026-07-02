{ ... }:

{
programs.bash = {
enableCompletion = true;

shellAliases = {
rm="rm -i";
mv="mv -i";
cp="cp -i";
ls="ls -A1 --color=auto";
grep="grep --color=auto";
".."="cd ..";
rmcache="rm -rf $HOME/.cache/*";
nrebuild="sudo nixos-rebuild switch --flake . --show-trace";
nupdate="nix flake update";
ngc="sudo nix-collect-garbage";
ngcall="sudo nix-collect-garbage -d";
nopt="sudo nix-store --optimise";
qsbin="quickshell -p Repos/configs/quickshell/shell/shell.qml";
qsstart="systemctl start --user quickshell.service";
qsstatus="systemctl status --user  quickshell.service";
qsrestart="systemctl restart --user quickshell.service";
qsstop="systemctl stop --user quickshell.service";
};

initExtra = ''
[[ ''$- != *i* ]] && return

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

FG_BLUE="\[\e[38;5;109m\]"
FG_GREEN="\[\e[38;5;142m\]"
FG_RED="\[\e[38;5;167m\]"
FG_SUBTEXT="\[\e[38;5;245m\]"
RESET="\[\e[0m\]"

set_prompt(){
local EXIT_STATUS=$?
local INDICATOR
if [ $EXIT_STATUS -eq 0 ]; then
INDICATOR="''${FG_GREEN}◆"
else
INDICATOR="''${FG_RED}◆"
fi
PS1=" ''${INDICATOR} ''${FG_SUBTEXT}\u@\h ''${FG_BLUE}[\w]''${RESET} ❯ "
}
PROMPT_COMMAND="set_prompt''${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

ex(){
if [ -z "$1" ]; then
echo "Uso: ex <arquivo>"
return 1
fi
if [ -f "$1" ]; then
case "$1" in
*.tar.bz2) tar xjf "$1" ;;
*.tar.gz) tar xzf "$1" ;;
*.bz2) bunzip2 "$1" ;;
*.rar) unrar x "$1" ;;
*.gz) gunzip "$1" ;;
*.tar) tar xf "$1" ;;
*.tbz2) tar xjf "$1" ;;
*.tgz) tar xzf "$1" ;;
*.zip) unzip "$1" ;;
*.Z) uncompress "$1" ;;
*.7z) 7z x "$1" ;;
*) echo "'$1' não foi possível extrair arquivos através do ex()" ;;
esac
else
echo "'$1' arquivo inválido."
fi
}
'';
};
}

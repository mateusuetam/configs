#!/bin/bash
VERDE='\033[0;32m'
AZUL='\033[0;34m'
AMARELO='\033[1;33m'
VERMELHO='\033[0;31m'
NC='\033[0m'
QUARANTENA="$HOME/Quarentena"
confirmar() {
read -p "$1 (s/n)? " resp
[[ "$resp" == "s" ]]
}
exe_scan() {
local alvo=$1
mkdir -p "$QUARANTENA"
sudo freshclam || echo -e "${VERMELHO}Falha ao executar o comando 'freshclam'.${NC}"
echo -e "${VERDE}Iniciando scan...${NC}"
sudo clamscan --exclude='/sys/kernel/debug/dri/' --max-filesize=2G --max-scansize=2G -r --move="$QUARANTENA/" "$alvo"
notify-send "Clamav" "Scan concluído!"
read -p "Pressione Enter para continuar..." dummy
}
while true;
do
echo -e "${VERMELHO}--- Clamav ---${NC}\n"
echo -e "${AMARELO}1. Arquivos sinalizados serão movidos para: $QUARANTENA\n"\
"2. O script tentará realizar uma atualização do banco de dados antes de um scan.${NC}\n"
echo -e "${VERDE}1) Scan completo\n2) Scan na pasta Home\n3) Scan na pasta Downloads\nq) Sair${NC}"
read -p "Escolha: " clam_op
case $clam_op in
1) confirmar "Prosseguir com o scan em todo sistema?" && exe_scan "/";;
2) confirmar "Prosseguir com o scan na pasta Home?" && exe_scan "$HOME";;
3) confirmar "Prosseguir com o scan na pasta Downloads?" && exe_scan "$HOME/Downloads";;
q|Q)
clear
exit 0
;;
*)
echo -e "${VERMELHO}Opção inválida.${NC}\n"
;;
esac
done

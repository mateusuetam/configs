#!/usr/bin/env bash
separator_paired="󰂱 ────────── Dispositivos Pareados ────────── 󰂱"
separator_scan="󰩊 ────────── Novos Dispositivos Achados ────────── 󰩊"
menu() {
rofi -dmenu -theme "$HOME/Documentos/repos/configs/rofi/menu.rasi" -p "$1"
}
bt() {
echo "$*" | bluetoothctl
}
clean() {
sed -r 's/\x1B\[[0-9;]*[mK]//g'
}
is_on() {
bluetoothctl show | grep -q "Powered: yes"
}
is_scanning() {
bluetoothctl show | grep -q "Discovering: yes"
}
toggle_power() {
if is_on; then
bluetoothctl power off
else
bluetoothctl power on
fi
}
get_clean_list() {
$1 | clean | grep -E "^Device ([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}" | sed 's/^Device //'
}
scan_menu() {
if ! is_scanning; then
bluetoothctl --timeout 60 scan on &
notify-send "Bluetooth" "Buscando novos dispositivos..."
fi
while true; do
paired_list=$(get_clean_list "bt devices Paired")
all_list=$(get_clean_list "bt devices")
new_list=$(echo -e "$paired_list\n$all_list" | sort | uniq -u)
options=$(printf "󰑐 Reescanear\n󰜺 Voltar\n%s\n%s" "$separator_scan" "$new_list")
choice=$(echo "$options" | grep -vE "^$|^[[:space:]]*$" | menu "Busca")
case "$choice" in
"󰑐 Reescanear")
bluetoothctl scan off && sleep 1
bluetoothctl --timeout 60 scan on &
notify-send "Bluetooth" "Reiniciando busca..."
continue
;;
"󰜺 Voltar" | "")
bluetoothctl scan off
return
;;
"$separator_scan") continue ;;
*)
mac=$(echo "$choice" | awk '{print $1}')
if [[ "$mac" =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
device_menu "$mac"
fi
;;
esac
done
}
connect_bt_device() {
local mac="$1"
bluetoothctl scan off
sleep 1
if ! bt info "$mac" | grep -q "Paired: yes"; then
notify-send "Bluetooth" "Pareando e confiando..."
bt trust "$mac"
sleep 1
if ! bt pair "$mac"; then
notify-send "Bluetooth" "Pareamento falhou"
return
fi
sleep 4
fi
bt trust "$mac"
for i in {1..5}; do
bt info "$mac" | grep -q "Trusted: yes" && break
sleep 1
done
local attempts=0
local max_attempts=3
local connected=false
while (( attempts < max_attempts )) && ! $connected; do
((attempts++))
notify-send "Bluetooth" "Tentativa $attempts de $max_attempts..."
bt connect "$mac" > /dev/null 2>&1
sleep 3
if bt info "$mac" | grep -q "Connected: yes"; then
connected=true
notify-send "Bluetooth" "Dispositivo conectado com sucesso!"
break
fi
if [ $attempts -lt $max_attempts ]; then
notify-send "Bluetooth" "Tentativa $attempts falhou, tentando novamente..."
sleep 1
fi
done
if ! $connected; then
notify-send "Bluetooth" "Falha ao conectar após $max_attempts tentativas."
fi
paired_list=$(get_clean_list "bt devices Paired")
all_list=$(get_clean_list "bt devices")
}
device_menu() {
mac="$1"
info="$(bt info "$mac")"
if echo "$info" | grep -q "Connected: yes"; then
connected="󰂲 Desconectar"
else
connected="󰂱 Conectar"
fi
if echo "$info" | grep -q "Trusted: yes"; then
trusted=" Desconfiar"
else
trusted=" Confiar"
fi
if echo "$info" | grep -q "Paired: yes"; then
pair_opt="󰆴 Desparear/Remover"
else
pair_opt="󰄄 Parear"
fi
choice=$(printf "%s\n%s\n%s\n󰜺 Voltar" "$connected" "$pair_opt" "$trusted" | menu "Dispositivo")
case "$choice" in
*Conectar)
connect_bt_device "$mac"
paired_list=$(get_clean_list "bt devices Paired")
all_list=$(get_clean_list "bt devices")
;;
*Desconectar) bt disconnect "$mac" && notify-send "Bluetooth" "Dispositivo $mac desconectado.";;
*Parear) bt pair "$mac" && notify-send "Bluetooth" "Dispositivo $mac emparelhado.";;
*Desparear*) bt remove "$mac" && notify-send "Bluetooth" "Dispositivo $mac removido." && sleep 1;;
*Confiar) bt trust "$mac" && notify-send "Bluetooth" "Dispositivo $mac confiado." ;;
*Desconfiar) bt untrust "$mac" && notify-send "Bluetooth" "Dispositivo $mac não mais confiado." ;;
esac
}
main_menu() {
while true; do
if ! is_on; then
choice=$(printf "󰂯 Ligar Bluetooth\n󰜺 Sair" | menu "Bluetooth")
[[ "$choice" == "󰂯 Ligar Bluetooth" ]] && toggle_power && sleep 1 && continue || exit
fi
paired_list=$(get_clean_list "bt devices Paired")
options=$(printf "󰂲 Desligar Bluetooth\n󰂰 Iniciar Busca de Dispositivos\n󰜺 Sair\n%s\n%s" "$separator_paired" "$paired_list")
choice=$(echo "$options" | grep -vE "^$|^[[:space:]]*$" | menu "Menu Principal")
case "$choice" in
"󰂲 Desligar Bluetooth") toggle_power ;;
"󰂰 Iniciar Busca de Dispositivos") scan_menu ;;
"󰜺 Sair" | "") exit ;;
"$separator_paired") continue ;;
*)
mac=$(echo "$choice" | awk '{print $1}')
if [[ "$mac" =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
device_menu "$mac"
fi
;;
esac
done
}
main_menu

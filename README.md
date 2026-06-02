# Meus Dots
Meus arquivos de customização e scripts pensados para um fluxo de trabalho em ambiente linux minimalista que se baseia no uso de window manager.

📦 Pacotes utilizados

• Window Manager: Niri

• Shell: Quickshell

• Terminal: Alacritty

• Editor de texto: Neovim

• App launcher: Rofi

• Lockscreen: Swaylock

• Idle listener: Swayidle

• Video player: MPV

• Protetor de luz azul: Gammastep

🧩 Plugins do Neovim

• Telescope (nvim-telescope)

• Alpha (goolord)

• Plenary (nvim-lua)

📜 Scripts e suas funções

Adendo: os scripts utilizam do rofi para fornecer a interface gráfica e mandam notificações através do notify-send.

• Bluetooth

- Liga ou Desliga o bluetooth (rfkill unblock/block).

- Realiza busca e emparelha com o dispositivo desejado (caso o primeiro scan não exiba nada, basta fazer um rescan para popular a lista).

- Exibe dispositivos emparelhados e fornece ações para conectar/desconectar, remover, confiar/desconfiar.

• Wifi

- Liga ou Desliga o wifi (nmcli radio on/off).

- Realiza scan e mostra o nome da rede, força do sinal, se é protegida por senha (é necessário nerd fonts/font awesome para ver o glyph) e o tipo de proteção.

- Ao tentar se conectar, é mostrada uma confirmação e, logo em seguida, uma tela de input para digitar a senha é mostrada (ainda não implementei as validações para verificar se a senha foi inserida corretamente).

- Exibe redes conectadas e fornece ações de conectar, desconectar e esquecer/remover.

• Redfilter

- Um menu para ativar/desativar o protetor de luz azul no modo padrão (2500k).

- Fornece a opção de definir um valor customizado entre 1000 ~ 10000 (valores maiores/menores poderiam tornar a visibilidade extremamente comprometida).

• Powermenu

- Um menu de sessão simples para sair da sessão, bloquear tela com o swaylock, suspender o computador, reiniciar ou desligar.

• ClamAV

- Pode realizar um scan completo, na pasta home ou de Downloads.

- Exclui a pasta /sys/kernel/debug/dri/ do scan para evitar que o sistema crashe.

- Atualiza o banco de dados do ClamAV antes de realizar um scan.

- Move arquivos sinalizados para uma pasta na pasta home chamada Quarentena (cria automaticamente caso não exista).

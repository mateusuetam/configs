{ config, lib, pkgs, ... }:

{
options.my.quickshell = {
enable = lib.mkEnableOption "Enable Quickshell UI";
development.enable = lib.mkEnableOption "Ferramentas de Desenvolvimento para a Quickshell";
};

config = lib.mkMerge [
(lib.mkIf config.my.quickshell.enable {
xdg.configFile."quickshell".source = ./shell;

home.packages = with pkgs; [
brightnessctl
gammastep
libnotify
monaspace
quickshell
wl-clipboard
];

services.cliphist.enable = true;

systemd.user.services.quickshell = {
Unit = {
Description = "Quickshell Wayland UI";
PartOf = [ "graphical-session.target" ];
After = [ "graphical-session.target" ];
};
Install = { WantedBy = [ "graphical-session.target" ]; };
Service = {
ExecStart = "${pkgs.quickshell}/bin/quickshell";
Restart = "on-failure";
KillMode = "process";
};
};
})

(lib.mkIf config.my.quickshell.development.enable {
home.packages = with pkgs; [
qtcreator
qt6.qtwayland

(symlinkJoin {
name = "qmllint-wrapped";
paths = [ qt6.qtdeclarative ];
nativeBuildInputs = [ makeWrapper ];
postBuild = ''
wrapProgram $out/bin/qmllint \
--add-flags "-I ${pkgs.qt6.qtdeclarative}/lib/qt-6/qml" \
--add-flags "-I ${pkgs.qt6.qtbase}/lib/qt-6/qml" \
--add-flags "-I ${pkgs.quickshell}/lib/qt-6/qml"
'';
})
];
})
];
}

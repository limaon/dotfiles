#!/usr/bin/env bash
#
# Website:       https://diolinux.com.br
# Autor:         Dionatan Simioni
#
# ------------------------------------------------------------------------ #
#
# COMO USAR?
#   $ ./pos_install.sh
#
# ----------------------------- VARIÁVEIS ----------------------------- #
set -e


##DIRETÓRIOS E ARQUIVOS

DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"
FILE="/home/$USER/.config/gtk-3.0/bookmarks"

#CORES

VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
SEM_COR='\e[0m'


#FUNÇÕES

# Atualizando repositório e fazendo atualização do sistema

pacman_update(){
  sudo pacman -Syyu
}

# -------------------------------------------------------------------------------- #
# -------------------------------TESTES E REQUISITOS----------------------------------------- #

# Internet conectando?
testes_internet(){
if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
  echo -e "${VERMELHO}[ERROR] - Seu computador não tem conexão com a Internet. Verifique a rede.${SEM_COR}"
  exit 1
else
  echo -e "${VERDE}[INFO] - Conexão com a Internet funcionando normalmente.${SEM_COR}"
fi
}

# ------------------------------------------------------------------------------ #



## ARCH SOFTWARES TO INSTALL

PROGRAMAS_PARA_INSTALAR=(
    adobe-source-han-sans-cn-fonts
    adobe-source-han-sans-jp-fonts
    adobe-source-han-sans-kr-fonts
    archlinux-keyring
    arandr
    autoconf
    automake
    base
    bash-completion
    binutils
    bison
    bluez
    bluez-utils
    blueman
    debugedit
    dunst
    efibootmgr
    efitools
    feh
    file
    file-roller
    findutils
    firefox
    firefox-i18n-en-us
    flex
    gettext
    polkit-gnome
    git
    gst-plugin-pipewire
    gufw
    gvfs
    gvfs-afc
    gvfs-gphoto2
    gvfs-mtp
    gvfs-nfs
    gvfs-smb
    gzip
    intel-media-driver
    intel-ucode
    iwd
    kitty
    libpulse
    libtool
    libva-intel-driver
    light
    lxappearance-gtk3
    m4
    man-db
    materia-gtk-theme
    mlocate
    mpv
    neovim
    networkmanager
    network-manager-applet
    nfs-utils
    nilfs-utils
    nitrogen
    openssh
    pacman
    papirus-icon-theme
    patch
    pavucontrol
    picom
    pipewire
    pipewire-alsa
    pipewire-jack
    pipewire-pulse
    pkgconf
    ranger
    slurp
    smartmontools
    sxiv
    texinfo
    thunar
    thunar-archive-plugin
    thunar-media-tags-plugin
    thunar-volman
    thunderbird
    thunderbird-i18n-en-us
    tmux
    ttf-dejavu
    ttf-joypixels
    ttf-liberation
    ttf-opensans
    transmission-gtk
    vulkan-intel
    wget
    which
    wireless_tools
    wireplumber
    wpa_supplicant
    xclip
    xdg-user-dirs
    xdg-utils
    xorg-server
    xorg-xinput
    xorg-xinit
    zathura
    zathura-cb
    zathura-djvu
    zathura-pdf-mupdf
    zathura-ps
    zram-generator
    keepassxc
    x11-ssh-askpass
)

# ---------------------------------------------------------------------- #

xdg-user-dirs-update

### Install paru
git clone https://aur.archlinux.org/paru.git $HOME/Downloads/paru
cd $HOME/Downloads/paru
makepkg -si

# ---------------------------------------------------------------------- #

INSTALL_AUR_PACKAGES=(
    ttf-nerd-fonts-hack-complete-git 
    otf-nerd-fonts-fira-code 
    nerd-fonts-inconsolata 
    nerd-fonts-jetbrains-mono 
    pfetch
    brillo
    xbanish
    ly
    asdf-vm
)

## Download e instalaçao de programas externos ##
install_pacman(){

# Instalar programas no pacman
echo -e "${VERDE}[INFO] - Instalando pacotes pacman do repositório${SEM_COR}"
for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
    sudo pacman -S --needed "$nome_do_programa"
done
echo -e "${VERDE}[INFO] - AUR Packages install${SEM_COR}"
for nome_do_programa in ${INSTALL_AUR_PACKAGES[@]}; do
    paru -S "$nome_do_programa"
done

}

# -------------------------------------------------------------------------- #
# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #


## Finalização, atualização e limpeza##

system_clean(){
    sudo pacman -Sc
}


# -------------------------------------------------------------------------- #
# ----------------------------- CONFIGS EXTRAS ----------------------------- #

sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now bluetooth.service 
sudo systemctl enable ly.service

systemctl --user enable --now geoclue-agent.service
systemctl --user enable --now ssh-agent

ln -s ~/.config/x11/xprofile ~/.profile

# -------------------------------------------------------------------------------- #
# -------------------------------EXECUÇÃO----------------------------------------- #


testes_internet
pacman_update
install_pacman
pacman_update
system_clean

## finalização
  echo -e "${VERDE}[INFO] - Script finalizado, instalação concluída! :)${SEM_COR}"

# Dotfiles setup

The configuration files and scripts that I utilize for my daily tasks.

## Details

- **Operating System** - [Arch Linux](https://www.archlinux.org/)
- **AUR Helper** - [paru](https://github.com/morganamilo/paru)
- **Terminal** - [kitty](https://sw.kovidgoyal.net/kitty/)
- **Window Manager** - [i3](https://i3wm.org/)
- **Status Bar** - [i3status](https://i3wm.org/i3status/)
- **Launcher** - [dmenu](https://tools.suckless.org/dmenu/)
- **Screen Locker** - [i3lock](https://i3wm.org/i3lock/)
- **Notification Daemon** - [dunst](https://dunst-project.org/)
- **Web Browser** - [firefox](https://wiki.archlinux.org/title/Firefox)
- **Email Client** - [thunderbird](https://wiki.archlinux.org/title/Thunderbird)
- **CLI File Manager** - [lf](https://github.com/gokcehan/lf)
- **GUI File Manager** - [thunar](https://docs.xfce.org/xfce/thunar/start)
- **Image Viewer** - [sxiv](https://nsxiv.codeberg.page/)(`nsxiv`)
- **Document Viewer** - [zathura](https://wiki.archlinux.org/title/Zathura)
- **Video player** - [mpv](https://mpv.io/)
- **Music** - [mpd](https://wiki.archlinux.org/title/Music_Player_Daemon) + [ncmpcpp](https://wiki.archlinux.org/title/Ncmpcpp)
- **Screenshots** - [maim](https://github.com/naelstrof/maim)
- **Text Editor** - [neovim](https://neovim.io/)
- **Youtube Downloader** - [yt-dlp (youtube-dl fork)](https://archlinux.org/packages/extra/any/yt-dlp/)
- **Shell** - [bash](https://www.gnu.org/software/bash/bash.html)
- **Completion** - [bash Completion](https://archlinux.org/packages/extra/any/bash-completion/)
- **Scripts** - [~/.local/bin/](https://github.com/limaon/dotfiles/tree/main/.local/bin)
- **Alias and Functions** - [.bash_aliases](https://github.com/limaon/dotfiles/tree/main/.bash_aliases)
- **Fonts**
  - [cantarell-fonts](https://archlinux.org/packages/extra/any/cantarell-fonts/)
  - [noto-fonts](https://archlinux.org/packages/extra/any/noto-fonts/)
  - [ttf-opensans](https://archlinux.org/packages/extra/any/ttf-opensans/)
  - [noto-fonts-cjk](https://archlinux.org/packages/extra/any/noto-fonts-cjk/)
  - [noto-fonts-emoji](https://archlinux.org/packages/extra/any/noto-fonts-emoji/)
  - [ttf-dejavu](https://archlinux.org/packages/extra/any/ttf-dejavu/)
  - [ttf-liberation](https://archlinux.org/packages/extra/any/ttf-liberation/)
  - [ttf-font-awesome](https://archlinux.org/packages/extra/any/ttf-font-awesome/)
  - [ttf-cascadia-code-nerd](https://archlinux.org/packages/extra/any/ttf-cascadia-code-nerd/)
  - [ttf-firacode-nerd](https://archlinux.org/packages/extra/any/ttf-firacode-nerd/)
  - [ttf-hack-nerd](https://archlinux.org/packages/extra/any/ttf-hack-nerd/)
  - [ttf-jetbrains-mono-nerd](https://archlinux.org/packages/extra/any/ttf-jetbrains-mono-nerd/)
  - [ttf-ubuntu-nerd](https://archlinux.org/packages/extra/any/ttf-ubuntu-nerd/)
  - [ttf-terminus-nerd](https://archlinux.org/packages/extra/any/ttf-terminus-nerd/)
- **Multimedia Framework**
  - **PipeWire**
    - [PipeWire](https://archlinux.org/packages/extra/x86_64/pipewire)
    - [PipeWire-Alsa](https://archlinux.org/packages/extra/x86_64/pipewire-alsa)
    - [PipeWire-Jack](https://archlinux.org/packages/extra/x86_64/pipewire-jack)
    - [Wireplumber](https://archlinux.org/packages/extra/x86_64/wireplumber)
    - [PipeWire-Pulse](https://archlinux.org/packages/extra/x86_64/pipewire-pulse)
    - [PipeWire-v4l2](https://archlinux.org/packages/extra/x86_64/pipewire-v4l2)

### Installation

1. Run the following commands in order.

```sh
git clone --depth=1 --bare "https://github.com/limaon/dotfiles.git" ~/.config/dotfiles
alias dot="git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/ --work-tree=$HOME"
dot config --local status.showUntrackedFiles no
mv .bashrc .bashrc_old
dot checkout
```

2. To install the packages from the AUR first install [paru](https://github.com/Morganamilo/paru)

```sh
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```
and run
```sh
paru -S --needed - < /.local/foreignpkglist.txt
```


## Main Keybindings

### Window manager controls

| Keys                           | Action          |
| ------------------------------ | --------------- |
| <kbd>MOD + Enter</kbd>         | Open Terminal   |
| <kbd>MOD + d</kbd>             | Open Launcher   |
| <kbd>MOD + q</kbd>             | Kill a Window   |
| <kbd>MOD + Shift + Space</kbd> | Toggle Floating |
| <kbd>MOD + Shift + e</kbd>     | Open PowerMenu  |

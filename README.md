# Dotfiles setup

This repository contains my personal configuration files (dotfiles) and scripts tailored for use on Arch Linux. These configurations streamline my development environment, ensuring consistency across all my projects and enhancing productivity.

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
- **GUI File Manager** - [thunar](https://wiki.archlinux.org/title/Thunar)
- **Image Viewer** - [sxiv](https://nsxiv.codeberg.page/)(`nsxiv`)
- **Document Viewer** - [zathura](https://wiki.archlinux.org/title/Zathura)
- **Video player** - [mpv](https://mpv.io/)
- **Music** - [mpd](https://wiki.archlinux.org/title/Music_Player_Daemon) + [ncmpcpp](https://wiki.archlinux.org/title/Ncmpcpp)
- **Screenshots** - [maim](https://github.com/naelstrof/maim)
- **Text Editor** - [neovim](https://neovim.io/)
- **Youtube Downloader** - [yt-dlp (youtube-dl fork)](https://archlinux.org/packages/extra/any/yt-dlp/)
- **Shell** - [bash](https://www.gnu.org/software/bash/bash.html)
- **Scripts** - [~/.local/bin/](https://github.com/limaon/dotfiles/tree/main/.local/bin)
- **Multimedia Framework**
  - **PipeWire**
    - [PipeWire](https://archlinux.org/packages/extra/x86_64/pipewire)
    - [PipeWire-Alsa](https://archlinux.org/packages/extra/x86_64/pipewire-alsa)
    - [PipeWire-Jack](https://archlinux.org/packages/extra/x86_64/pipewire-jack)
    - [Wireplumber](https://archlinux.org/packages/extra/x86_64/wireplumber)
    - [PipeWire-Pulse](https://archlinux.org/packages/extra/x86_64/pipewire-pulse)
    - [PipeWire-v4l2](https://archlinux.org/packages/extra/x86_64/pipewire-v4l2)

### Installation

1. Run the following command below.

```sh
bash <(curl -L https://tinyurl.com/tbs4u39a)
```

2. To install the packages from the AUR first install [paru](https://github.com/Morganamilo/paru)

```sh
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
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

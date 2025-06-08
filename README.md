# Dotfiles setup

This repository has my personal setup files (dotfiles) and scripts made for Arch Linux. These files help me keep my work environment the same for all my projects and make me more productive.

![screenshots](https://github.com/user-attachments/assets/2e0fd9e6-148f-4228-8f3a-7b55edfbeb6a)

## Details

- Distro - [Arch Linux](https://www.archlinux.org/)
- Shell - bash + [Bash-it](https://github.com/Bash-it/bash-it)
- AUR Helper - [paru](https://github.com/morganamilo/paru)
- Terminal - [kitty](https://sw.kovidgoyal.net/kitty/)
- WM - [i3](https://i3wm.org/)
- Status Bar - [i3status](https://i3wm.org/i3status/)
- Launcher - [dmenu](https://tools.suckless.org/dmenu/)
- Screen Locker - [i3lock](https://i3wm.org/i3lock/)
- Notification Daemon - [dunst](https://dunst-project.org/)
- CLI File Manager - [lf](https://github.com/gokcehan/lf)
- GUI File Manager - [pcmanfm](https://wiki.archlinux.org/title/PCManFM)
- Fuzzy finder - [fzf](https://wiki.archlinux.org/title/Fzf)
- Image Viewer - [sxiv](https://nsxiv.codeberg.page/)(`nsxiv`)
- Document Viewer - [zathura](https://wiki.archlinux.org/title/Zathura)
- Video player - [mpv](https://mpv.io/)
- Volume -
  [pulsemixer](https://archlinux.org/packages/extra/any/pulsemixer/),
  [pamixer](https://archlinux.org/packages/extra/x86_64/pamixer/),
  [pavucontrol](https://archlinux.org/packages/extra/x86_64/pavucontrol/)
- Music - [mpd](https://wiki.archlinux.org/title/Music_Player_Daemon) + [ncmpcpp](https://wiki.archlinux.org/title/Ncmpcpp)
- Screenshots - [maim](https://github.com/naelstrof/maim)
- Text Editor - [neovim](https://neovim.io/)
- Youtube Downloader - [yt-dlp (youtube-dl fork)](https://archlinux.org/packages/extra/any/yt-dlp/)
- Scripts - [~/.local/bin/](https://github.com/limaon/dotfiles/tree/main/.local/bin)

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


### Credits

Some configurations in this repository were built based on [tatsumoto-ren](https://github.com/tatsumoto-ren/dotfiles). Thanks to the original author for providing a great foundation and inspiration for my own setup.

## My personal configs

### Installing dotfiles

```sh
echo 'alias dotconfig="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"' >> $HOME/.bashrc
source ~/.bashrc
git clone --bare https://github.com/limaon/dotfiles.git $HOME/.dotfiles
mv .bashrc .bashrc_old
dotconfig checkout
dotconfig config --local status.showUntrackedFiles no
```

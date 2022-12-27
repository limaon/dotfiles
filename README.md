## My personal configs

### Installing dotfiles

```sh
alias dotconfig="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"' 
echo ".dotfiles" >> .gitignore
git clone --bare https://github.com/limaon/dotfiles.git $HOME/.dotfiles
mv .bashrc .bashrc_old
dot checkout
dot config --local status.showUntrackedFiles no
```

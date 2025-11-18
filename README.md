# rubydots

dotfiles!

## Setup

```bash
cd rubydots

# create symlinks
stow --verbose --target=$HOME --restow */

# remove symlinks
stow --verbose --target=$HOME --delete */

# useful aliases
alias dot='cd ~/dot'
alias d.='cd ~/dot; yazi'
alias dotlink='cd ~/dot; stow --verbose --target=$HOME --restow */; cd -'
alias dotlinkrm='cd ~/dot; stow --verbose --target=$HOME --delete */; cd -'
alias cpcw='cd ~/dot; copilot -p "create commits for files, use conventional commit styling" --allow-tool "shell(git commit)" --allow-tool "shell(git add)"; cd -'
```

## Dependencies

```bash
# One-liner for pacman
sudo pacman -S yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick atuin bat kitty btop dunst libnotify git git-delta lazygit neovim tree-sitter tree-sitter-cli starship

# Hyprland (-git from AUR)
yay -S hyprland-protocols-git hyprwayland-scanner-git hyprutils-git hyprgraphics-git hyprlang-git hyprcursor-git aquamarine-git xdg-desktop-portal-hyprland-git hyprland-git hypridle-git hyprlock-git hyprpaper-git hyprpicker-git hyprpolkitagent-git hyprsunset-git hyprland-guiutils-git hyprland-qt-support-git hyprqt6engine-git hyprland-preview-share-picker hyprtoolkit-git


#### Individual installs by package ####

# yazi - filemanager
sudo pacman -S yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick

# atuin - shell history
sudo pacman -S atuin

#bat - cat replacement
sudo pacman -S bat

#kitty - terminal emulator
sudo pacman -S kitty

#btop - htop replacement
sudo pacman -S btop

# dunst - notification daemon
sudo pacman -S dunst libnotify

# git - duh
sudo pacman -S git git-delta

# lazygit - git client
sudo pacman -S lazygit

# neovim
sudo pacman -S neovim tree-sitter tree-sitter-cli

# starship - shell prompt
sudo pacman -S starship
```

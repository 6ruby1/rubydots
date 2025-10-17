#!/bin/zsh

# Run order:
# 1. .zshenv     | Set major env variables
# 2. .zprofile   | Set minor env variables
# 3. .zshrc      | Zsh config

#### PATH #### -------------------------------

export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.local/share/bin

#### FPATH #### ------------------------------

export FPATH=$FPATH:$HOME/.config/zsh/functions

#### ENV #### --------------------------------

export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

export HYPRSHOT_DIR=/home/ruby/Pictures/screenshots

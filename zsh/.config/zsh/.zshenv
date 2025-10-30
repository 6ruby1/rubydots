#!/bin/zsh

# Run order:
# 1. .zshenv     | Set major env variables
# 2. .zprofile   | Set minor env variables
# 3. .zshrc      | Zsh config

# Location for zsh configuration (also set in $HOME/.zshenv)
export ZDOTDIR=${ZDOTDIR:-$HOME/.config/zsh}

# XDG
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-$HOME/.xdg}
export XDG_PROJECTS_DIR=${XDG_PROJECTS_DIR:-$HOME/Projects}

# Coloured sudo prompt
export SUDO_PROMPT="$(tput setab 1 setaf 7 blink bold)[sudo]$(tput sgr0) $(tput setaf 2 bold)password for %p:$(tput sgr0) "

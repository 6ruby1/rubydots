#!/bin/zsh

# Run order:
# 1. .zshenv     | Set major env variables
# 2. .zprofile   | Set minor env variables
# 3. .zshrc      | Zsh config

#### PATH #### -------------------------------

export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.local/share/bin
export PATH=$PATH:~/bin

#### FPATH #### ------------------------------

export FPATH=$FPATH:$HOME/.config/zsh/functions

#### ENV #### --------------------------------

export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

export HYPRSHOT_DIR=$HOME/Pictures/screenshots

#### SECRETS FROM .env #### ------------------

envfile=".env"
if [ -f "$envfile" ]; then
  while IFS= read -r line || [ -n "$line" ]; do
    # trim leading whitespace
    line="${line#"${line%%[![:space:]]*}"}"
    # trim trailing whitespace
    line="${line%"${line##*[![:space:]]}"}"
    # skip empty lines and comments
    case "$line" in
    '' | \#*) continue ;;
    esac
    # only accept KEY=VALUE
    if [[ "$line" == *=* ]]; then
      export "$line"
    fi
  done <"$envfile"
fi

# Includes:
# - Obsidian local REST API key

#### XDG-NINJA #### --------------------------

export CARGO_HOME=$XDG_DATA_HOME/cargo
export DOCKER_CONFIG=$XDG_CONFIG_HOME/docker

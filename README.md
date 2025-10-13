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
  # yazi
  sudo pacman -S yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick
```

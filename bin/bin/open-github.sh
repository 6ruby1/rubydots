#! /bin/bash
cd "$(tmux run 'echo #{pane_current_path}')" || exit 1
url=$(git remote get-url origin)
url="${url/git@github.com:/https:\/\/github.com/}"

xdg-open "$url" || echo "No remote found"

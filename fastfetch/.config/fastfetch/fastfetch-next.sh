#!/usr/bin/env bash

# Select the next ascii art (must be .txt) to display.
# remembers the last selected file in a state file so the next run picks the following file (wraps around).
# returns the file contents (ASCII art).
# Optionally provide a hex color to colorize the
# output (truecolor / 24-bit ANSI: \033[38;2;R;G;Bm).
#
# Usage:
#   ./fastfetch-next.sh [DIR]
#   ./fastfetch-next.sh -c <hex> [DIR]
#   ./fastfetch-next.sh --color <hex> [DIR]
#
# Examples:
#   ./fastfetch-next.sh              # use current dir, no color
#   ./fastfetch-next.sh art_dir      # use art_dir, no color
#   ./fastfetch-next.sh -c ff00aa    # use current dir, color #ff00aa
#   ./fastfetch-next.sh -c "#0f0" art_dir  # 3-digit hex supported
set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-"$HOME/.local/state"}"
STATE_FILE="$STATE_DIR/fastfetch-next.state"

usage() {
  cat <<EOF
Usage: $(basename "$0") [-c HEX|--color HEX] [DIR]
Select the next .txt file from DIR (default: .). Only files directly inside DIR
are considered (no subdirectory search). The script prints the file contents
(ASCII art) to stdout. If -c/--color HEX is given the output is wrapped in a
24-bit color escape for the provided hex color (accepts RRGGBB or RGB, with or
without a leading '#').

State is stored in:
  $STATE_FILE
EOF
  exit 2
}

# default values
DIR="."
color_hex=""

# simple args parsing: options first, then optional DIR
while [[ $# -gt 0 ]]; do
  case "$1" in
  -c | --color)
    shift
    if [ $# -eq 0 ]; then
      printf 'Error: missing argument for %s\n' "$1" >&2
      usage
    fi
    color_hex="$1"
    shift
    ;;
  -h | --help)
    usage
    ;;
  --)
    shift
    break
    ;;
  -*)
    printf 'Unknown option: %s\n' "$1" >&2
    usage
    ;;
  *)
    DIR="$1"
    shift
    ;;
  esac
done

if [ ! -d "$DIR" ]; then
  printf 'Error: %s is not a directory\n' "$DIR" >&2
  usage
fi

mkdir -p "$(dirname "$STATE_FILE")"

# canonicalize path (best effort)
abspath() {
  local p="$1"
  if command -v realpath >/dev/null 2>&1; then
    realpath -m -- "$p"
  else
    if [ -d "$p" ]; then
      (cd "$p" 2>/dev/null && pwd -P) || printf '%s\n' "$p"
    else
      case "$p" in
      /*) printf '%s\n' "$p" ;;
      *) printf '%s\n' "$(pwd -P)/$p" ;;
      esac
    fi
  fi
}
DIR_ABS="$(abspath "$DIR")"

# Build file list: only regular files directly in DIR matching *.txt (case-insensitive)
shopt -s nullglob
shopt -s nocaseglob

matches=("$DIR_ABS"/*.txt)

# restore shell options to previous state
shopt -u nocaseglob 2>/dev/null || true
shopt -u nullglob 2>/dev/null || true

filtered=()
for f in "${matches[@]}"; do
  [ -f "$f" ] || continue
  filtered+=("$f")
done

# deterministic sort (prefer null-terminated sort when available)
files=()
if printf '' | sort -z >/dev/null 2>&1; then
  mapfile -d '' -t files < <(printf '%s\0' "${filtered[@]}" | sort -z)
else
  mapfile -t files < <(printf '%s\n' "${filtered[@]}" | sort)
fi

if [ "${#files[@]}" -eq 0 ]; then
  printf 'No .txt files found directly in %s\n' "$DIR_ABS" >&2
  exit 1
fi

# read last selected file if present
last_selected=""
if [ -f "$STATE_FILE" ]; then
  IFS= read -r last_selected <"$STATE_FILE" || true
fi

# find index of last_selected and compute next index (wrap)
next_index=0
if [ -n "$last_selected" ]; then
  for i in "${!files[@]}"; do
    if [ "${files[$i]}" = "$last_selected" ]; then
      next_index=$(((i + 1) % ${#files[@]}))
      break
    fi
  done
fi

selected="${files[$next_index]}"

if [ ! -r "$selected" ]; then
  printf 'Error: selected file %s is not readable\n' "$selected" >&2
  exit 1
fi

# helper: parse hex (RGB or RRGGBB, optional leading '#') into integer r/g/b
parse_hex_to_rgb() {
  local raw="$1"
  local hex="${raw#\#}"
  # allow 3 or 6 hex digits
  if [[ ! "$hex" =~ ^[0-9A-Fa-f]{3}$ ]] && [[ ! "$hex" =~ ^[0-9A-Fa-f]{6}$ ]]; then
    return 1
  fi
  if [[ "${#hex}" -eq 3 ]]; then
    # expand e.g. "f0a" -> "ff00aa"
    hex="${hex:0:1}${hex:0:1}${hex:1:1}${hex:1:1}${hex:2:1}${hex:2:1}"
  fi
  # extract components and convert to decimal using base-16 arithmetic
  r=$((16#${hex:0:2}))
  g=$((16#${hex:2:2}))
  b=$((16#${hex:4:2}))
  printf '%d %d %d' "$r" "$g" "$b"
  return 0
}

# if color provided, validate and build ANSI sequence
color_prefix=""
color_suffix=""
if [ -n "${color_hex:-}" ]; then
  if rgb_vals=$(parse_hex_to_rgb "$color_hex"); then
    # shellsplit
    read -r r g b <<<"$rgb_vals"
    # produce 24-bit foreground color sequence
    color_prefix=$(printf '\033[38;2;%d;%d;%dm' "$r" "$g" "$b")
    color_suffix=$(printf '\033[0m')
  else
    printf 'Error: invalid hex color: %s\n' "$color_hex" >&2
    printf 'Expected formats: RRGGBB, #RRGGBB, RGB, or #RGB (hex digits)\n' >&2
    exit 2
  fi
fi

# save selected file so next run rotates
printf '%s\n' "$selected" >"$STATE_FILE"

# output: wrap with color if requested, using cat to print contents
if [ -n "$color_prefix" ]; then
  # print prefix (interpreting escape sequences), contents, then reset
  printf '%b' "$color_prefix"
  cat -- "$selected"
  # ensure reset and newline
  printf '%b\n' "$color_suffix"
else
  cat -- "$selected"
fi

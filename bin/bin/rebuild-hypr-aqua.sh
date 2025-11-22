#!/usr/bin/env bash
# Rebuild only INSTALLED packages whose names contain "(hypr|aqua)", excluding "*-debug".
# Rebuild all packages in a single command (preserving the requested priority order).
#
# Priority order (rebuilt first if present):
#   hyprland-protocols hyprwayland-scanner hyprutils hyprgraphics hyprlang
#   hyprcursor aquamarine xdg-desktop-portal-hyprland hyprland
#
# Usage:
#   ./rebuild-hypr-aqua.sh         # interactive: shows plan, asks for confirmation
#   ./rebuild-hypr-aqua.sh -n      # dry-run: print commands but don't run them
#   ./rebuild-hypr-aqua.sh -y      # non-interactive: pass --noconfirm to yay/paru
set -euo pipefail

DRY_RUN=false
YES=false

print_usage() {
  cat <<EOF
Usage: $0 [-n|--dry-run] [-y|--yes] [-h|--help]

  -n, --dry-run   Print what would be done but don't execute rebuilds.
  -y, --yes       Run non-interactively: pass --noconfirm to yay/paru.
  -h, --help      Show this help.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  -n | --dry-run)
    DRY_RUN=true
    shift
    ;;
  -y | --yes)
    YES=true
    shift
    ;;
  -h | --help)
    print_usage
    exit 0
    ;;
  *)
    echo "Unknown arg: $1"
    print_usage
    exit 2
    ;;
  esac
done

# Detect helpers; prefer yay, fallback to paru. The user asked for a single yay command;
# if yay is not present we'll still print the single yay command for manual use.
HELPER=""
if command -v yay >/dev/null 2>&1; then
  HELPER="yay"
elif command -v paru >/dev/null 2>&1; then
  HELPER="paru"
fi

# Priority order (will be rebuilt first if present)
priority=(
  hyprland-protocols-git
  hyprwayland-scanner-git
  hyprutils-git
  hyprgraphics-git
  hyprlang-git
  hyprcursor-git
  aquamarine-git
  xdg-desktop-portal-hyprland-git
  hyprland-git
)

# Discover INSTALLED packages containing "hypr" or "aqua", excluding "*-debug"
mapfile -t discovered < <(
  pacman -Qq 2>/dev/null |
    grep -Ei -- '(hypr|aqua)' |
    grep -Ev -- '-debug$' |
    awk '!seen[$0]++'
)

if [[ ${#discovered[@]} -eq 0 ]]; then
  echo "No INSTALLED packages found matching (hypr|aqua) (excluding *-debug)."
  exit 0
fi

# Build ordered list: prioritized packages first (if present), then the rest in discovered order
ordered=()
pkgs=("${discovered[@]}")

for p in "${priority[@]}"; do
  for i in "${!pkgs[@]}"; do
    if [[ "${pkgs[i]}" == "$p" ]]; then
      ordered+=("$p")
      unset 'pkgs[i]'
      break
    fi
  done
  pkgs=("${pkgs[@]}")
done

# Append remaining packages (if any)
if [[ ${#pkgs[@]} -gt 0 ]]; then
  ordered+=("${pkgs[@]}")
fi

echo "Found ${#discovered[@]} INSTALLED package(s) matching (hypr|aqua) (excluding *-debug):"
for p in "${discovered[@]}"; do printf "  - %s\n" "$p"; done
echo
echo "Rebuild order (prioritized first):"
for p in "${ordered[@]}"; do printf "  -> %s\n" "$p"; done
echo

if $DRY_RUN; then
  echo "DRY RUN: no rebuilds will be executed."
fi

if [[ -z "$HELPER" ]]; then
  echo "Warning: no AUR helper (yay/paru) found in PATH."
  echo "The script will not execute rebuilds, but will print the single yay command that would rebuild all packages."
  echo
fi

if ! $DRY_RUN && ! $YES; then
  read -r -p "Proceed to rebuild these INSTALLED packages in one command? [y/N] " ans
  case "$ans" in
  [Yy] | [Yy][Ee][Ss]) ;;
  *)
    echo "Aborted."
    exit 0
    ;;
  esac
fi

# prepare helper options
helper_opts=()
if $YES; then
  helper_opts+=(--noconfirm)
fi

# Build and run (or print) a single command that rebuilds everything in order.
if [[ ${#ordered[@]} -eq 0 ]]; then
  echo "Nothing to rebuild."
  exit 0
fi

# If helper is present, use it; otherwise print a suggested yay command.
if [[ -n "$HELPER" ]]; then
  cmd=("$HELPER" -S --rebuild "${ordered[@]}" "${helper_opts[@]}")
  if $DRY_RUN; then
    printf "DRY: %s\n" "${cmd[*]}"
    exit 0
  fi

  echo "Running single ${HELPER} command to rebuild all packages in order..."
  if "${cmd[@]}"; then
    echo "All packages rebuilt (helper: $HELPER)."
    exit 0
  else
    echo "Rebuild failed (helper: $HELPER)." >&2
    exit 2
  fi
else
  # No helper found: print single yay command for the user to run manually.
  single_cmd=("yay" "-S" "--rebuild")
  single_cmd+=("${ordered[@]}")
  if $YES; then
    single_cmd+=(--noconfirm)
  fi
  printf "Suggested single yay command to run (preserves order):\n\n  %s\n\n" "$(printf '%q ' "${single_cmd[@]}")"
  exit 0
fi

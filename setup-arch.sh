#!/usr/bin/env bash

# ==========================
# PART ONE
# --------
# Need to install YAY first.
# =========================
if ! command -v yay &>/dev/null; then

  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si

  cd ..
  rm -r yay
  echo "Yay installed succesfully!"
else
  echo "Yay is already installed. Skipping."
fi

# ==========================
# PART TWO
# --------
# Install of the programs
# =========================

# Programming
APPS_programming=(
  fish
  ghostty
  starship
  nvim
  zed
)

# Tools
APPS_tools=(
  bat
  btop
  duf
  eza
  fastfetch
  fd
  fx
  fzf
  git
  git-delta
  glow
  hexyl
  lazygit
  ripgrep
  tldr
  stow
  yazi
  zoxide
)

APPS_other=(
  google-chrome
  zen-browser-bin
  discord
)

# The following deps are installed to give more functionality to Yazi
# Yazi may have other deps that are also installed but because I use them directly (e.g. ripgrep)
APPS_yazi_deps=(
  ffmpeg    # video preview
  jq        # JSON preview
  p7zip     # Archive preview
  poppler   # PDF preview
)

ALL_APPS=(
  "${APPS_programming[@]}"
  "${APPS_tools[@]}"
  "${APPS_other[@]}"
  "${APPS_yazi_deps[@]}"
)

yay -S --needed --noconfirm "${ALL_APPS[@]}"


# ==========================
# PART THREE
# --------
# Configure everything.
# =========================

# Configure tools

# Configure Git
git config --global user.email valter.c.santos@protonmail.com
git config --global user.name 'Valter Santos'
git config --global core.editor nvim
git config --global rerere.enabled true

# delta
# Add delta as default
git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global merge.conflictstyle zdiff3

#### Configure Keyboard input Speed
if [[ "$XDG_CURRENT_DESKTOP" == "KDE" ]]; then
  kwriteconfig6 --file kcminputrc --group Keyboard --key RepeatDelay 200
  kwriteconfig6 --file kcminputrc --group Keyboard --key RepeatRate 60
fi

# Setup symlinks
stow -t ~/.config config/

# Update default shell
if [[ "$SHELL" != "/usr/bin/fish" ]]; then
    chsh -s /usr/bin/fish
else
    echo "Shell is already fish. Skipping."
fi

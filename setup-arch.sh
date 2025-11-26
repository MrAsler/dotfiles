#!/usr/bin/env bash

# TODO: Add Autologin for SDDM
sudo

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

APPS_system=(
  ufw
  unzip 
  uwsm
  wl-clipboard
  waybar
  dua
  dust
  sddm
  bluetui
)

APPS_hyprland=(
  wayland
  hyprland
  hyprlock
  hyprland-guiutils
  hypridle
  mako
)

APPS_app_launcher=(
  elephant
  elephant-calc
  elephant-clipboard
  elephant-bluetooth
  elephant-desktopapplications
  elephant-files
  elephant-menus
  elephant-providerlist
  elephant-runner
  elephant-symbols
  elephant-unicode
  elephant-websearch
  elephant-todo
  walker
)

APPS_cli=(
  bat
  duf
  eza 
  fd
  fzf
  fx
  git
  git-delta
  glow 
  hexyl 
  ripgrep
  tldr
  stow
  zoxide
)

APPS_tui=(
  btop
  lazygit
  impala
  fastfetch
  yazi
)

APPS_gui=(
  satty
  google-chrome
  zen-browser-bin
  discord
  spotify-launcher
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
  "${APPS_system[@]}"
  "${APPS_cli[@]}"
  "${APPS_tui[@]}"
  "${APPS_gui[@]}"
  "${APPS_yazi_deps[@]}"
  "${APPS_app_launcher[@]}"
  "${APPS_hyprland[@]}"
)

yay -Sya --needed --noconfirm "${ALL_APPS[@]}"


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

#### Configure Firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# Setup symlinks
stow -t ~/.config config/

# Update default shell
if [[ "$SHELL" != "/usr/bin/fish" ]]; then
    chsh -s /usr/bin/fish
else
    echo "Shell is already fish. Skipping."
fi


#### SDDM

if ! systemctl is-enabled getty@tty1.service >/dev/null 2>&1; then
  sudo systemctl enable getty@tty1.service
fi
if ! systemctl is-enabled sddm.service >/dev/null 2>&1; then
  sudo systemctl enable sddm.service
fi

#### Elephant / Walker
elephant service enable
systemctl --user start elephant.service

systemctl --user restart elephant.service
systemctl --user restart app-walker@autostart.service


sudo systemctl daemon-reload

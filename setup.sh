#!/usr/bin/env bash

which -s brew
if [[ $? != 0 ]] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
fi

# Programming
BREW_programming=(
  fish 
  ghostty
  starship
  nvim
  zed
)

# Tools
BREW_tools=(
  git 
  bat 
  git-delta
  fx 
  fzf 
  duf 
  btop
  hexyl 
  glow 
  fd
  eza 
  zoxide 
  ripgrep
  tldr
  lazygit
  fastfetch
  yazi
  zellij
)

BREW_casks=(
  zen-browser
  font-jetbrains-mono-nerd-font
)

BREW_macos_casks=(
  alt-tab
)

# Install everything
brew install --quiet ${BREW_programming[@]} ${BREW_tools[@]}
brew install --quiet --cask ${BREW_casks[@]} ${BREW_macos_casks[@]}

# Configure MacOS

mkdir -p ~/Developer
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 1
defaults write http://com.apple.finder AppleShowAllFiles YES
export XDG_CONFIG_HOME="$HOME/.config" # Required for lazygit

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

# Copy config files to correct locations
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cp -r $SCRIPT_DIR/config ~/.config/

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
  yazi
  zellij
  zoxide 
)

# The following deps are installed to give more functionality to Yazi
# Yazi may have other deps that are also installed but because I use them directly (e.g. ripgrep)
BREW_yazi_deps=(
  ffmpeg    # video preview
  jq        # JSON preview
  p7zip     # Archive preview
  poppler   # PDF preview
)

BREW_casks=(
  zen-browser
  font-jetbrains-mono-nerd-font
)

BREW_macos_casks=(
  alt-tab
)

# Install everything
brew install --quiet ${BREW_programming[@]} ${BREW_tools[@]} ${BREW_yazi_deps[@]}
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


## SYNC CONFIGS

CURRENT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TARGET_DIR="$HOME/.config"

APPS_WITH_CONFIGS=(
  ghostty
  lazygit
  nvim
  yazi
  zed
)

for appName in ${APPS_WITH_CONFIGS[@]}; do
  rm -r $TARGET_DIR/$appName
  ln -s $CURRENT_DIR/config/$appName $TARGET_DIR/
  echo "Updated symlink for $appName"
done

# Explictly only copy the fish config file 
cp $CURRENT_DIR/config/fish/config.fish $HOME/.config/fish/config.fish

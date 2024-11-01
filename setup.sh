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
    alacritty 
    nvim
    zed
)

# Tools
BREW_tools=(
    git 
    bat 
    diff-so-fancy
    fx 
    fzf 
    duf 
    htop
    hexyl 
    glow 
    fd
    eza 
    zoxide 
    ripgrep
    tldr
    lazygit
)

BREW_casks=(
    font-jetbrains-mono-nerd-font
)

# Install everything
brew install ${BREW_programming[@]} ${BREW_tools[@]}
brew install --cask ${BREW_casks[@]}

# Configure MacOS

mkdir ~/Developer
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 1
defaults write http://com.apple.finder AppleShowAllFiles YES

# Configure tools
 
# Configure Git
git config --global user.email valter.c.santos@protonmail.com
git config --global user.name 'Valter Santos'
git config --global core.editor nvim
git config --global rerere.enabled true

# diff-so-fancy
# Add diff-so-fancy as default
git config --global core.pager "diff-so-fancy | less --tabs=4 -RF"
git config --global interactive.diffFilter "diff-so-fancy --patch"

# Copy config files to correct locations
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# Fish
cp $SCRIPT_DIR/config/fish/config.fish ~/.config/fish/config.fish

# alacritty
cp -a $SCRIPT_DIR/config/alacritty/ ~/.config/alacritty/

# nvim 
cp -a $SCRIPT_DIR/config/nvim/ ~/.config/nvim

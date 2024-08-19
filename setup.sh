which -s brew
if [[ $? != 0 ]] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    brew update
fi

# Programming
brew install fish
brew install alacritty
brew install nvim

fish_add_path /opt/homebrew/bin

# Tools
brew install git
brew install bat 
brew install diff-so-fancy
brew install fx
brew install fzf
brew install duf
brew install htop
brew install hexyl
brew install glow
brew install fd
brew install eza
brew install zoxide
brew install ripgrep
brew install tldr

# Configure tools
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
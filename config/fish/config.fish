if status is-interactive
    # Commands to run in interactive sessions can go here
end

# fx - JSON viewer 
# https://fx.wtf/install 
# Add auto complete to shell
fx --comp fish | source

# fzf - Fuzzy finder
# https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
# Set up fzf key bindings
fzf --fish | source

# zoxide - a better CD
# Set up zoxide for fish
zoxide init fish | source

# Alias
alias cat bat
alias eza ls
alias cd z
alias vim nvim
alias vi nvim

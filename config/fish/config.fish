if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path /opt/homebrew/bin/
set fish_greeting

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

# Update config home
export XDG_CONFIG_HOME="$HOME/.config" # Required for lazygit

# https://yazi-rs.github.io/docs/quick-start/
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# Setup starship: https://starship.rs/
starship init fish | source


# Alias
alias cat bat
alias eza ls
alias cd z
alias vim nvim
alias vi nvim

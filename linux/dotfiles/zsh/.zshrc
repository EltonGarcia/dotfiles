
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' max-errors 1 numeric
zstyle :compinstall filename "$HOME/.zshrc"

# Use modern completion system
autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.config/histfile
HISTSIZE=100000
SAVEHIST=100000
setopt beep
#bindkey -v # set vim keybindings
bindkey -e # set emacs keybindings
# End of lines configured by zsh-newuser-install

# bitwarden
export SSH_AUTH_SOCK="$HOME"/snap/bitwarden/current/.bitwarden-ssh-agent.sock

# neovim
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
alias vim='nvim'

# wezterm
alias wezterm='flatpak run org.wezfurlong.wezterm'
source "$HOME"/.config/wezterm/assets/shell-integration/wezterm.sh

# zsh
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# starship 
eval "$(starship init zsh)"


# Bindkeys - view: man zshzle
set -o vi # set zsh to use vi-style line editing
bindkey -v # set 'viins' keymap - view keybinds: bindkey -M viins
#bindkey -e # set 'emacs' keymap - view keybinds: bindkey -M emacs

# vi mode
#export KEYTIMEOUT=1

# custom keybinds
bindkey -M viins 'jj' vi-cmd-mode
#bindkey -M viins "^@" set-mark-command
bindkey -M viins "^A" beginning-of-line
bindkey -M viins "^E" end-of-line
#bindkey -M viins "^B" backward-char
#bindkey -M viins "^F" forward-char
bindkey -M viins "^G" send-break
#bindkey -M viins "^M" accept-line
bindkey -M viins "^P" up-line-or-history
bindkey -M viins "^N" down-line-or-history
bindkey -M viins "^O" accept-line-and-down-history
bindkey -M viins "^Q" push-line
#bindkey -M viins "^S" history-incremental-search-forward
bindkey -M viins "^K" kill-line
bindkey -M viins "^W" backward-kill-word

# Use vim keys in tab complete menu:
#bindkey -M menuselect 'h' vi-backward-char
#bindkey -M menuselect 'k' vi-up-line-or-history
#bindkey -M menuselect 'l' vi-forward-char
#bindkey -M menuselect 'j' vi-down-line-or-history
#bindkey -v '^?' backward-delete-char

# enable edit command line in vim (CTRL+X, CTRL+E)
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M viins "^X^E" edit-command-line

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

#zle-line-init() {
#    #zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
#    echo -ne "\e[5 q"
#}
#zle -N zle-line-init

echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

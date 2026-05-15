#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
# git
alias g='git'
# misc
alias c='clear'
alias ls='ls --color=auto'
alias lsa='ls -a --color=auto'
alias grep='grep --color=auto'
alias src='source ~/.bashrc'
alias cfg='cd ~/.config/hypr/ && nvim hyprland.conf'
alias lg='lazygit'
alias bt='bluetui'
alias oc='opencode'
alias cc='claude'
alias zed='zeditor'
alias z='zeditor'
alias kd='killall -9 Discord'
alias bld='./build.sh'

# bun
alias dev="bun run dev"
alias lint="bun run lint"
alias tc="bun run typecheck"
alias repl="bun repl"
# cds
alias ..='cd ..'
alias wrk='cd ~/Workspace/'
alias soko="cd ~/Workspace/playdate-sokobon/"
alias dot="cd ~/Workspace/.dotfiles/"

PS1='[\u@\h \W]\$ '

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(starship init bash)"
[[ $- == *i* ]] && bind -f ~/inputrc
export PATH="$HOME/.local/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/tpolito/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Set Playdate SDK path (replace with the actual SDK folder)
# Playdate SDK
export PLAYDATE_SDK_PATH="$HOME/.Playdate"
export PATH="$PLAYDATE_SDK_PATH/bin:$PATH"

# opencode
export PATH=/home/tpolito/.opencode/bin:$PATH

# commands
fastfetch

# Shell Configuration
# Bash completion settings
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
bind "set show-all-if-ambiguous on"
bind "set completion-ignore-case on"
PS1="[\u@\h \W]\$ "
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
export PATH="$HOME/.tfenv/bin:$PATH"
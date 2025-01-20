if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
bind "set show-all-if-ambiguous on"
bind "set completion-ignore-case on"

# Docker cleanup alias
alias docker-clean='docker stop $(docker ps -aq) 2>/dev/null; \
docker rm $(docker ps -aq) 2>/dev/null; \
docker rmi $(docker images -q) -f 2>/dev/null; \
docker volume rm $(docker volume ls -q) 2>/dev/null; \
docker network rm $(docker network ls -q) 2>/dev/null; \
echo "Docker cleanup completed!"'

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Path configuration
export PATH="$HOME/.tfenv/bin:$PATH"

# History settings
HISTCONTROL=ignoredups
shopt -s histappend
PROMPT_COMMAND="history -a"

# Enhanced prompt with virtual env support
if [ -n "$VIRTUAL_ENV" ]; then
    PS1='($(basename "$VIRTUAL_ENV"))\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# Enable cd without typing cd
shopt -s autocd 2>/dev/null

# VI mode
set -o vi
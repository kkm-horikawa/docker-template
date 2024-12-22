# ZSH Configuration
alias docker-clean='docker stop $(docker ps -aq) 2>/dev/null; \
docker rm $(docker ps -aq) 2>/dev/null; \
docker rmi $(docker images -q) -f 2>/dev/null; \
docker volume rm $(docker volume ls -q) 2>/dev/null; \
docker network rm $(docker network ls -q) 2>/dev/null; \
echo "Docker cleanup completed!"'
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
export PATH="$HOME/.tfenv/bin:$PATH"
autoload -Uz compinit && compinit
zstyle ":completion:*" menu select
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
PROMPT="%n@%m:%~$ "
if [[ -n "$VIRTUAL_ENV" ]]; then
    PROMPT="(`basename \"$VIRTUAL_ENV\"`)$PROMPT"
fi
setopt autocd
setopt extended_history
setopt share_history
setopt hist_ignore_dups
bindkey -e
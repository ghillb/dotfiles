#!/bin/sh

alias s='sudo '
alias se='sudoedit'
alias sc='systemctl'
alias jc='journalctl -xe'
alias update='sudo apt update && sudo apt upgrade'
alias updateall='sudo apt update && sudo apt -y upgrade && brew upgrade && sudo snap refresh && cargo install-update -a'
alias in='sudo apt install'
alias un='sudo apt remove'
alias cd='cdls'
alias mv='mv -i'
alias x='xsel -ib'
alias rs='rsync -hP'
alias encrypt='tar -czO input | gpg -c > output.tar.gpg'
alias decrypt='gpg -d input | tar xzvf -'
alias g='git'
alias tf='terraform'
alias a='ansible'
alias k='kubectl'
alias ap='ansible-playbook'
alias d='docker'
alias dc='docker-compose'
alias dstop='docker stop $(docker ps -a -q)'
alias dps='docker ps -a --format="table {{.ID}} {{.Names}}\t{{.Status}}\t{{.Image}}"'
alias dmrm='docker-machine rm $(docker-machine ls -q)'
alias ark='arkade'
alias c='cat'
alias icat="kitty +kitten icat"
alias n='nnn -e -P p'
alias N='sudo -E nnn -deCH -P p'
alias e='xplr'
alias tree='tree --du -h'
alias open='dopen'
alias z='zathura'
alias ga='git add'
alias glo='git log --all --graph --oneline'
alias gls='git log --all --graph --oneline --stat'
alias glu='git log --stat @{u}..HEAD'
alias glp='git log -p'
alias gg='git status -s'
alias gcb='git checkout $(git branch --sort=-committerdate | fzf --height=40% --layout=reverse)'
alias gc='git checkout'
alias gd='git diff'
alias gdu='git diff @{push}...HEAD'
alias gds='git diff --staged'
alias gf='git fetch'
alias gps='git -c push.default=current push'
alias gpl='git -c pull.default=current pull'
alias gss='git stash'
alias gsp='git stash pop'
alias gsubin='git submodule update --init --recursive'
alias gsubpl='git submodule foreach --recursive git pull origin HEAD'
alias gbin="grep -Fvxf <(git grep -Il '') <(git grep -al '')"
alias gl='glab'
alias gr='gitlab-runner exec docker'
alias gi='onefetch'
alias ci='tokei'
alias sadd="eval $(ssh-agent) ssh-add"
alias lg='lazygit'
alias ld='lazydocker'
alias py='python3'
alias jn='jupyter notebook'
alias fu='curl -F"file=@$(find $HOME -type f | fzf)" 0x0.st | xsel --input --clipboard'
alias hist='history|grep'
alias hx='hexyl'
alias vr='nvr -r'
alias vt='nvim -c term -c "norm i" -c "setlocal ls=0 cc= rnu! nu!" -c "au!" -c "au TermClose * :q!"'
alias ss='shellcheck'
alias stx='mop -profile ~/.config/mop/default-moprc.json'
alias tcr='ticker --config ~/.config/default-ticker.yaml --show-separator'
alias reloadwp='feh --bg-scale ~/.wallpaper'
alias khpa='watch kubectl get hpa -n '
alias kpods='watch kubectl top pods -n  -l app='
alias hf='hyperfine'

if ! command -v exa &> /dev/null; then alias ll='ls -alF'; else alias ll='exa -alFg'; fi
if ! command -v nvim &> /dev/null; then alias v='vi -p'; else alias v='nvim -p'; fi


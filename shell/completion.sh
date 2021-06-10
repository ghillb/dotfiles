#!/usr/bin/env bash    

if [[ ! -d ~/.bash_completion.d  ]]; then
  mkdir ~/.bash_completion.d
  curl https://raw.githubusercontent.com/ghillb/complete-alias/master/complete_alias \
      > ~/.bash_completion.d/complete_alias
fi

source ~/.bash_completion.d/complete_alias

if command -v minikube &>/dev/null; then
  eval "$(minikube completion bash)"
fi

if command -v kubectl &>/dev/null; then
  eval "$(kubectl completion bash)"
  complete -F __start_kubectl k
fi

if command -v helm &>/dev/null; then
  eval "$(helm completion bash)"
fi

if command -v terraform &>/dev/null; then
  complete -C /usr/bin/terraform terraform -F _complete_alias tf
fi

if command -v glab &>/dev/null; then
  eval "$(glab completion -s bash)"
  complete -F _complete_alias gl
fi

if command -v gh &>/dev/null; then
  eval "$(gh completion -s bash)"
fi

if command -v kitty &>/dev/null; then
  source <(kitty + complete setup bash)
fi

if command -v docker &>/dev/null; then
  complete -F _complete_alias d
fi

if command -v docker-compose &>/dev/null; then
  complete -F _complete_alias dc
fi

if command -v sudo &>/dev/null; then
  complete -F _complete_alias s
fi

if command -v git &>/dev/null; then
  complete -F _complete_alias g
fi

if command -v arkade &>/dev/null; then
  eval "$(arkade completion bash)"
  complete -F _complete_alias ark
fi

if command -v kind &>/dev/null; then
  eval "$(kind completion bash)"
fi

if command -v kompose &>/dev/null; then
  source <(kompose completion bash)
fi

if command -v ansible &>/dev/null; then
  source ~/.bash_completion.d/ansible-completion.bash
  complete -F _complete_alias a
fi

if command -v rustc &>/dev/null; then
  source $(rustc --print sysroot)/etc/bash_completion.d/cargo
fi

function_exists m && complete -F _command m
function_exists ped && complete -F _command ped


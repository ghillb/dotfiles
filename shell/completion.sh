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

if command -v glab &>/dev/null; then
  eval "$(glab completion -s bash)"
  complete -F _complete_alias gl
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

if command -v git &>/dev/null;
  then complete -F _complete_alias g
fi

function_exists m && complete -F _command m


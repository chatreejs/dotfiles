DISTRO=$(source ${HOME}/.zsh/include.sh)

function kn() {
  namespace=$1
  if [ -z $namespace ]; then
    echo "Please provide the namespace name: e.g., 'kn mywebapp'"
    return 1
  fi

  kubectl config set-context $(kubectl config current-context) --namespace $namespace
}

function kc() {
  context=$1
  
  if [ -z $context ]; then
    echo "Please provide the context name: e.g., 'kc mycontext'"
    return 1
  fi

  kubectl config use-context $context
}

function flushdns() {
  if [[ $_distro == "macos" ]]; then
    sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
  elif [[ $_distro == "ubuntu" || $_distro == "debian" ]]; then
    sudo systemd-resolve --flush-caches
  fi
  echo "DNS cache flushed"
}

function reload() {
  echo "Reloading Zsh configuration..."
  source ~/.zshrc
  echo "Zsh configuration reloaded"
}

# Alias command
alias vi="lvim"
alias g="goto"
alias grep='grep --color'

# Alias for Kubernetes
alias k="kubectl"
alias h="helm"
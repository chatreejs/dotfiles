source ${HOME}/.zsh/utils/include.sh
source ${HOME}/.zsh/utils/kubernetes.sh
source ${HOME}/.zsh/utils/network.sh

function reload() {
    echo "Reloading Zsh configuration..."
    source ~/.zshrc
    echo "Zsh configuration reloaded"
}

# Alias command
alias ll='ls -la'
alias l='ls -l'
alias vi="lvim"
alias grep='grep --color'

# Alias for Kubernetes
# `k` is defined as a function in utils/kubernetes.sh (pipes YAML output to yq)
alias h="helm"

# Utility
alias backupfile="bash ${HOME}/.zsh/utils/backupfile.sh"

[[ -f ~/.zsh/omz.zsh ]] && source ~/.zsh/omz.zsh
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh
[[ -f ~/.zsh/starship.zsh ]] && source ~/.zsh/starship.zsh
[[ -f ~/.zsh/zsh-completions.zsh ]] && source ~/.zsh/zsh-completions.zsh

# Load Starship
eval "$(starship init zsh)"

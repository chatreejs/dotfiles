[[ -f ~/.zsh/omz.zsh ]] && source ~/.zsh/omz.zsh
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh
[[ -f ~/.zsh/starship.zsh ]] && source ~/.zsh/starship.zsh
[[ -f ~/.zsh/zsh-completions.zsh ]] && source ~/.zsh/zsh-completions.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/chanont/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/chanont/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/chanont/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/chanont/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Load Starship
eval "$(starship init zsh)"

eval $(thefuck --alias)

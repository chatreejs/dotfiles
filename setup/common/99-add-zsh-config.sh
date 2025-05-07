#!bin/bash

echo "🔗  $(tput setaf 6)Setup zsh configuration$(tput sgr0)"

add_line_if_not_exists() {
    local line="$1"
    local file="$2"
    grep -qxF "$line" "$file" || echo "$line" >> "$file"
}

temp_file=$(mktemp)
{
    echo 'export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"'
    echo '[[ -f ~/.zsh/omz.zsh ]] && source ~/.zsh/omz.zsh'
    echo '[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh'
    echo '[[ -f ~/.zsh/starship.zsh ]] && source ~/.zsh/starship.zsh'
    echo '[[ -f ~/.zsh/zsh-completions.zsh ]] && source ~/.zsh/zsh-completions.zsh'
} > "$temp_file"

# Create a backup of the original .zshrc
cp ~/.zshrc ~/.zshrc.bak

# Add lines to the top of .zshrc if they do not exist
new_content=""
echo $new_content
while IFS= read -r line; do
    if ! grep -qxF "$line" ~/.zshrc; then
        new_content+="$line"$'\n'
    fi
done < "$temp_file"

# Prepend the new content to the original .zshrc
echo -e "$new_content$(cat ~/.zshrc.bak)" > ~/.zshrc

rm "$temp_file"
rm ~/.zshrc.bak

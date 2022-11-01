set fish_greeting ""

set -gx TERM xterm-256color

# Theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# Alias
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g goto
alias grep "grep --color"

# Load fish config
switch (uname)
    case Darwin
        source (dirname (status --current-filename))/config-osx.fish
    case Linux
        source (dirname (status --current-filename))/config-linux.fish
    case '*'
        source (dirname (status --current-filename))/config-windows.fish
end

# Find out which distro we are running on
set LINUX_FILE "/etc/*-release"
set MAC_FILE "/System/Library/CoreServices/SystemVersion.plist"

if test -f $LINUX_FILE
    set _distro $(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
else if test -f $MAC_FILE
    set _distro macos
end

# Set an icon based on the distro
# Make sure your font is compatible with https://github.com/lukas-w/font-logos
switch $_distro
    case '*kali*'
        set ICON "ﴣ"
    case '*arch*'
        set ICON ""
    case '*debian*'
        set ICON ""
    case '*raspbian*'
        set ICON ""
    case '*ubuntu*'
        set ICON ""
    case '*elementary*'
        set ICON ""
    case '*fedora*'
        set ICON ""
    case '*coreos*'
        set ICON ""
    case '*gentoo*'
        set ICON ""
    case '*mageia*'
        set ICON ""
    case '*centos*'
        set ICON ""
    case '*opensuse*' '*tumbleweed*'
        set ICON ""
    case '*sabayon*'
        set ICON ""
    case '*slackware*'
        set ICON""
    case '*linuxmint*'
        set ICON ""
    case '*alpine*'
        set ICON ""
    case '*aosc*'
        set ICON ""
    case '*nixos*'
        set ICON ""
    case '*devuan*'
        set ICON ""
    case '*manjaro*'
        set ICON ""
    case '*rhel*'
        set ICON ""
    case '*macos*'
        set ICON ""
    case '*'
        set ICON ""
end

set -gx STARSHIP_DISTRO "$ICON"

# Load Starship
starship init fish | source

#!/bin/bash

function flushdns() {
    if [[ $_distro == "macos" ]]; then
        sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
        elif [[ $_distro == "ubuntu" || $_distro == "debian" ]]; then
        sudo systemd-resolve --flush-caches
    fi
    echo "DNS cache flushed"
}

function myip() {
	local IP=$(curl -s https://ipinfo.io/ip)
	echo "ipv4: $IP"
}

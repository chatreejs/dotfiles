#!/bin/bash

# find out which distribution we are running on
LFILE="/etc/os-release"
MFILE="/System/Library/CoreServices/SystemVersion.plist"
if [[ -f $LFILE ]]; then
    _distro=$(awk '/^ID=/' /etc/*-release 2>/dev/null | awk -F'=' '{ print tolower($2) }')
    elif [[ -f $MFILE ]]; then
    _distro="macos"
fi

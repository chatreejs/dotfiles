#!/bin/bash

log_step "🔧  Key repeat"

defaults write -g ApplePressAndHoldEnabled -bool false
log_done "Key repeat enabled (press-and-hold disabled)"

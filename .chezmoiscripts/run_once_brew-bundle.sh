#!/usr/bin/env bash

if type brew &>/dev/null; then
    brew bundle --file ~/.local/share/chezmoi/Brewfile
fi

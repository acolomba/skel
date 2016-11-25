#!/bin/bash

cd $(dirname "$0") || exit 1

# copies all the dotfiles to the home directorhy
umask 0077
for df in dotfiles/*; do
    dst_df="${HOME}/.$(basename "${df}")"

    cp -rf "${df}" "${dst_df}"
done

case $(uname) in
    Darwin)
        # sets up brew
        if ! which -s brew; then
            umask 0022
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || exit 1
        fi

        # taps
        while read -u 42 tap; do
            if [[ ! -z ${tap} ]]; then
                echo "Tapping ${tap}"
                brew tap "${tap}"
            fi
        done 42<packages/homebrew/taps


        # installs the base set of packages
        while read -u 42 formula; do
            if ! brew 2>/dev/null list --versions "${formula}" |grep >/dev/null '^'; then
                # if formula not already installed, installs it
                brew install "${formula}"
            fi
        done 42<packages/homebrew/formulae
        ;;

    Linux)
        # makes sure it's a standard base distro
        if which lsb_release >/dev/null; then
            case $(lsb_release -s -i) in
                Debian|Ubuntu)
                    sudo apt-get install $(cat packages/apt/packages)
                ;;
            esac
        fi
    ;;
esac

# installs mac apps via brew cask
while read -u 42 formula; do
    if ! brew cask list "${formula}" >/dev/null; then
        # if app not already installed, installs it
        brew cask install "${formula}"
    fi
done 42<packages/homebrew/casks

case $(uname) in
    Darwin)
        st_settings_home="$HOME/Library/Application Support/Sublime Text 3"
        ;;
    Linux)
        st_settings_home="$HOME/.config/sublime-text-3"
        ;;
esac

if [[ -d $st_settings_home ]]; then
    echo "Sublime settings already exist. Skipping."
else
    cp -rf "conf/sublime-text-3" "${st_settings_home}"
fi

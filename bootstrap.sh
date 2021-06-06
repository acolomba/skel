#!/usr/bin/env bash

cd $(dirname "$0") || exit 1

# copies all the dotfiles to the home directory
umask 0077
for df in dotfiles/*; do
    dst_df="${HOME}/.$(basename "${df}")"

    echo "Copying ${df}"
    if [[ -f $df ]]; then
        cp "${df}" "${dst_df}"
    else
        mkdir -p "${dst_df}"
        (cd "${df}" && tar -cf - * |tar -xf - -C "${dst_df}")
    fi
done

# installs packages
case $(uname) in
    Darwin)
        # sets up brew
        if ! which -s brew; then
            umask 0022
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi

        # homebrew taps
        while read -u 42 tap; do
            if [[ ! -z ${tap} ]]; then
                echo "Tapping ${tap}"
                brew tap "${tap}"
            fi
        done 42<packages/homebrew/taps

        # homebrew formulae
        while read -u 42 formula; do
            if ! brew 2>/dev/null list --versions "${formula}" |grep >/dev/null '^'; then
                # if formula not already installed, installs it
                brew install "${formula}"
            fi
        done 42<packages/homebrew/formulae

        # homebrew casks casks
        while read -u 42 cask; do
            if ! brew list --cask "${cask}" 2>/dev/null; then
                # if app not already installed, installs it
                brew install --cask "${cask}" --force
            fi
        done 42<packages/homebrew/casks

        # installs mac app store applications
        if mas account 1>/dev/null; then
            while read -u 42 appname; do
                if ! mas list |fgrep -q " $appname ("; then
                    # parses out the app id from the app store search; a typical
                    # format is <id> Some App (<version>); we need to match the
                    # whole "Some App" part to avoid partial matches, and then
                    # use the id
                    appid=$(mas search "${appname}" |grep "[0-9]\+ \+${appname} \+(" |sed -E 's/^ *([0-9]+) .*/\1/')

                    if [[ $appid ]]; then
                        mas install "${appid}"
                    else
                        echo >&2 "Application does not exist in the App Store : ${appname}"
                    fi
                fi
            done 42<packages/macapps/applications
        else
            echo >&2 "Error: Sign in to the App Store and repeat this setup. Continuing..."
        fi
        ;;

    FreeBSD)
        if which -s sudo; then
            sudo pkg install -y $(cat packages/pkg/packages)
        else
            echo >2 "Error: Please install sudo with \"pkg install sudo\", edit /usr/local/etc/sudoers from the root account, and add \"$(whoami) ALL=(ALL) ALL\""
            exit 1
        fi
        ;;

    Linux)
        # makes sure it's a known standard base distro
        if which lsb_release >/dev/null; then
            case $(lsb_release -s -i) in
                Debian|Ubuntu)
                    sudo apt-get install $(cat packages/apt/packages)
                ;;
            esac
        fi
        ;;
esac


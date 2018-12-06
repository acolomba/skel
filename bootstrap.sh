#!/usr/bin/env bash

cd $(dirname "$0") || exit 1

# copies all the dotfiles to the home directory
umask 0077
for df in dotfiles/*; do
    dst_df="${HOME}/.$(basename "${df}")"

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

        # installs mac apps via brew cask
        while read -u 42 formula; do
            if ! brew cask list "${formula}" >/dev/null; then
                # if app not already installed, installs it
                brew cask install "${formula}" --force
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
                    appid=$(mas search "${appname}" |awk -v appname=" ${appname}" '{ appid=$1; $1=""; if ($0 == appname) print appid; }')

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

# sublime settings home
case $(uname) in
    Darwin)
        st_settings_home="$HOME/Library/Application Support/Sublime Text 3"
        ;;
    Linux)
        st_settings_home="$HOME/.config/sublime-text-3"
        ;;
esac

# writes sublime settings unless they already exist
if [[ $st_settings_home ]] && [[ -d $st_settings_home ]]; then
    echo "Sublime settings already exist. Skipping."
else
    # creates .config if it doesn't exist
    if [[ ! -d $HOME/.config ]]; then
        mkdir "$HOME/.config/"
    fi

    cp -rf "conf/sublime-text-3" "${st_settings_home}"
fi

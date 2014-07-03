#!/bin/bash

cd $(dirname "$0") || exit 1

# parses cmdline options
USAGE="Usage: $(basename $0) [-hl]"
while getopts :hl opt; do
    case $opt in
        h)
            echo $USAGE
            exit 0
            ;;
        l)
            link_only=1
            ;;
        \?)
            echo >&2 $USAGE
            exit 1
            ;;
    esac
done

# copies or links the file at $1 to the location at $2; both paths must be
# filenames (i.e. no cp x d/), with $1 relative to this script's location
cpln() {
    if [[ $link_only ]]; then
        # if requested to create links to dotfiles, does so
        ln -sf "$(pwd)/$1" "$2"
    else
        # otherwise removes links (if any)...
        if [[ -L $2 ]]; then
            echo >&2 "Removing symlink $2"
            rm "$2"
        fi

        # .. and copies the file
        cp "$1" "$2"
    fi
}

dotfiles=( ackrc bash_profile bashrc inputrc nethackrc screenrc vimrc )
umask 0077

for df in "${dotfiles[@]}"; do
    dst_df="${HOME}/.${df}"

    cpln "${df}" "${dst_df}"
done

shift $(expr $OPTIND - 1)

# sublime text settings
st_settings_homes=( "$HOME/Library/Application Support/Sublime Text 3" "$HOME/.config/sublime-text-3" )

for st_settings_home in "${st_settings_homes[@]}"; do
    if [[ -d "$st_settings_home/Packages/User" ]]; then
        st_user_settings_path=""${st_settings_home}/Packages/User""
    fi
done

if [[ $st_user_settings_path ]]; then
    cpln "conf/sublime-text-3/Preferences.sublime-settings" "${st_user_settings_path}"

    st_settings_filename=Preferences.sublime-settings
    st_settings_path="${st_user_settings_path}/${st_settings_filename}"

    cpln "conf/sublime-text-3/Preferences.sublime-settings" "${st_settings_path}"
fi


# macosx specific
if [[ $(uname) = 'Darwin' ]]; then
    # if running os x

    # sets up brew
    if ! which -s brew; then
        ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)" || exit 1
    fi

    # taps
    brew tap caskroom/cask >/dev/null
    brew tap homebrew/games >/dev/null

    # installs the base set of packages
    for formula in ack autojump bash bash-completion2 brew-cask git links mercurial nethack proxytunnel python source-highlight tig unnethack unrar vim watch wget; do
        if ! brew 2>/dev/null list --versions $formula |grep >/dev/null '^'; then
            # installs package if not already installed
            brew install $formula
        fi
    done

    # installs mac apps via brew cask
    for formula in cord firefox flux google-chrome google-earth grandperspective istat-menus harvest keyremap4macbook mailplane seil sourcetree spotify virtualbox; do
        if ! brew cask 2>/dev/null list $formula |grep >/dev/null '^'; then
            # installs app if not installed already
            brew cask install $formula
        fi
    done
fi

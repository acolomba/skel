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
            link_dotfiles=1
            ;;
        \?)
            echo >&2 $USAGE
            exit 1
            ;;
    esac
done

dotfiles=( bash_profile bashrc inputrc nethackrc screenrc vimrc )
umask 0077

for df in "${dotfiles[@]}"; do
    dst_df="${HOME}/.${df}"

    if [[ $link_dotfiles ]]; then
        # if requested to create links to dotfiles, does so
        ln -sf "$(pwd)/${df}" "${dst_df}"
    else
        # otherwise removes links (if any)...
        if [[ -L ${dst_df} ]]; then
            echo >&2 "Removing symlink .${df}"
            rm "${dst_df}"
        fi

        # .. and copies dotfiles
        cp "${df}" "${dst_df}"
        # || { echo "Could not copy .${df} into home folder"; exit 1 }
    fi
done

shift $(expr $OPTIND - 1)

# vim stuff
for vd in "~/.vim/backups" "~/.vim/swaps"; do
    if [[ ! -d $vd ]]; then
        mkdir -p "$vd"
    fi
done

if [[ $(uname) = 'Darwin' ]]; then
    # if running os x

    # sets up brew
    if which brew >/dev/null; then
        # taps
        brew tap homebrew/games >/dev/null

        # if brew installed, checks that we have the base set of packages
        for formula in elinks irssi mercurial nethack proxytunnel python python python source-highlight tinyproxy unnethack unrar vim vim watch wget wget python; do
            if [[ -z $(brew which $formula) ]]; then
                # installs package if not already installed
                brew install $formula
            fi
        done
    else
        # or warns it's not yet installed
        echo >&2 "WARN: brew is not installed. Install with: 'ruby -e \"\$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)\"'"
    fi
fi

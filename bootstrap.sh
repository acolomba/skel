#!/bin/bash

cd $(dirname "$0") || exit 1

dotfiles=( bash_profile bashrc inputrc nethackrc screenrc vimrc )
umask 0077

for df in "${dotfiles[@]}"; do
    dst_df="${HOME}/.${df}"
    if [[ -L ${dst_df} ]]; then
        echo >&2 "Removing symlink .${df}"
        rm "${dst_df}"
    fi

    cp "${df}" "${dst_df}"
    # || { echo "Could not copy .${df} into home folder"; exit 1 }
done

for vd in "~/.vim/backups" "~/.vim/swaps"; do
    if [[ ! -d $vd ]]; then
        mkdir -p "$vd"
    fi
done

if [[ $(uname) = 'Darwin' ]]; then
    if which brew >/dev/null; then
        # taps
        brew tap homebrew/games >/dev/null

        # if brew installed, checks that we have the base set of packages
        for formula in elinks irssi mercurial nethack proxytunnel python python python tinyproxy unnethack unrar vim vim watch wget wget python; do
            if [[ -z $(brew which $formula) ]]; then
                # installs package if not already installed
                brew install $formula
            fi
        done
    else
        echo >&2 "NOTE: brew is not installed"
    fi
fi


# TODO
# brew tap homebrew/games
# brew install elinks install mercurial nethack proxytunnel python python python screen tinyproxy tsocks unnethack unrar vim vim watch wget wget python


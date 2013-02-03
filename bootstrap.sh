#!/bin/sh

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
    # || { echo "Could not copy .${df} into home folder" }
done


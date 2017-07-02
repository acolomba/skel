# skel

## Overview

Configures a new or existing host with dotfiles, command-line tools and applications. Supports macOS, FreeBSD and Debian/Ubuntu Linux.

On macOS, applications are installed via Homebrew casks and the App Store.

## Running

After reviewing the prerequisites and notes below, execute from your user account with:

    ./bootstrap.sh

The script can be run multiple times after pulling new versions or changing the dotfiles or the list of packages and applications.

## Prerequisites

### macOS

In macOS, you must first install XCode from the App Store and accept its license by either running XCode once, or by issuing this command:

    sudo xcodebuild -license

### FreeBSD

In FreeBSD, you will need to manually install some packages from the root account:

    pkg install bash git sudo

After that, you will need to add your normal user account to the sudoers, by adding this line to `/usr/local/etc/sudoers` from the root account:

    <your username> ALL=(ALL) ALL


## Dotfiles

This script overwrites any existing dotfiles with those located in the `dotfiles/` directory.

The `.bash_profile` and `.bashrc` files contain code to make sure they both run exactly once for every kind of shell -- login or not, interactive or not --, in all platforms. They will also source `.bash_profile_local` and `.bashrc_local` respectively for any machine-specific customization.

## Packages and Applications

### macOS

On macOS, this script will automatically install Homebrew formulae/casks and applications from the App Store.

Before running the bootstrap script, review the contents of these files:

* `packages/homebrew/taps`: sources of packages, in case you want to add any.
* `packages/homebrew/formulae`: command-line tools, e.g. bash 4.x, vim et al.;
* `packages/homebrew/casks`: applications, e.g. Google Chrome, Java et al.;
* `packages/macapps/applications`: applications from the App Store, e.g. Slack, VOX et al.

The ability to install from the App Store relies on the `mas` formula in `packages/homebrew/formulae`.

### FreeBSD

On FreeBSD, review the list of packages in `packages/pkg/packages`.

### Linux

On Linux, review the list of packages in `packages/apt/packages`.

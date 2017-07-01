# skel

## Overview

Configures a new host with dotfiles, command-line tools and applications. Supports macOS and Debian/Ubuntu Linux.

After reviewing the prerequisites and notes below, execute from your user account with:

    ./bootstrap.sh

## Prerequisites

### macOS

In macOS, you must first install XCode from the App Store and accept its license by either running XCode once, or by issuing this command:

    sudo xcodebuild -license

## Dotfiles

This script overwrites any existing dotfiles with those located in the `dotfiles/` directory.

The `.bash_profile` and `.bashrc` files contain code to make sure they both run exactly once for every kind of shell -- login or not, interactive or not --, in all platforms. They will also source `.bash_profile_local` and `.bashrc_local` respectively for any machine-specific customization.

## Packages and Applications

### macOS

On macOS, this script will automatically install homebrew formulae and casks. 

Before running the bootstrap script, review the contents of these files:

* `packages/homebrew/formulae`: command-line tools, e.g. bash 4.x, vim, et al.;
* `packages/homebrew/casks`: applications, e.g. Google Chrome, Java, et al.;
* `packages/homebrew/taps`: sources of packages, in case you want to add any.

### Linux

On Linux, review the list of packages in `packages/apt/packages`.

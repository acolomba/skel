# dotfiles

## Overview

Maintains dotfiles with [chezmoi](https://www.chezmoi.io).

## Prerequisites

### macOS

- [Homebrew](https://brew.sh)
- chezmoi: `brew install chezmoi`

### Other

<https://www.chezmoi.io/install/>

## Running

### macOS

```sh
chemoiz -- init --apply $GITHUB_USERNAME
```

### Other

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply acolomba
```

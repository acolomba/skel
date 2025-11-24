# dotfiles

## Overview

Maintains dotfiles with [chezmoi](https://www.chezmoi.io).

On macOS, a set of Brew formulas and casks are automatically installed once.

## Prerequisites

### macOS

- [Homebrew](https://brew.sh)
- chezmoi: `brew install chezmoi`

### Other

<https://www.chezmoi.io/install/>

## Running

### macOS

```sh
chezmoi init --apply --verbose acolomba
```

### Other

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply acolomba
```

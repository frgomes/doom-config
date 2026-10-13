#!/usr/bin/env bash

set -euo pipefail

# install DoomEmacs, if not installed yet
[[ -d ~/.config ]] || mkdir -p ~/.config
[[ -d ~/.config/emacs ]] || git clone --depth 1 https://github.com/doomemacs/core ~/.config/emacs

# clone this repository
[[ -d ~/workspace ]] || mkdir -p ~/workspace
[[ -d ~/workspace/doom-config ]] || git clone http://github.com/frgomes/doom-config ~/workspace/doom-config

# create symbolic links, if not there yet
[[ -d ~/bin ]] || mkdir -p ~/bin
[[ -L ~/.config/doom ]] || ln -s ~/workspace/doom-config ~/.config/doom
[[ -L ~/bin/doom ]]     || ln -s ~/.config/emacs/bin/doom ~/bin/doom 

# install packages and sync
~/bin/doom install
~/bin/doom sync

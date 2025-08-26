# doom

My [DoomEmacs](https://github.com/doomemacs/doomemacs) configuration under ~/.config/doom

## Installation

```bash
# clone this repository
mkdir -p ~/workspace
cd ~/workspace
git clone http://github.com/frgomes/doom-config

# create symbolic links, if not there yet
mkdir -p ~/.config
[[ -L ~/.config/doom ]] || ln -s ~/workspace/doom-config ~/.config/doom
[[ -L ~/bin/doom ]]     || ln -s ~/.config/emacs/bin/doom ~/bin/doom 

# upgrade packages and sync
doom upgrade
doom sync
```

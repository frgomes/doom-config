# doom

My [DoomEmacs](https://github.com/doomemacs/doomemacs) configuration under ~/.config/doom

## Installation

```bash
# clone this repository
mkdir -p ~/workspace
cd ~/workspace
git clone http://github.com/frgomes/doom-config

# create symbolic link, if not there yet
mkdir -p ~/.config
[[ -L ~/.config/doom ]] || ln -s ~/workspace/doom-config ~/.config/doom
```

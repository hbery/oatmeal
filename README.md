# Dotfiles

## Steps to install

> You can install all things separately by searching all installation scripts
```bash
find "${PWD}" -wholename "**/install*.sh" -print -exec chmod u+x {} \;
```

> Or you can use the all-around script
```bash
chmod u+x ./install-dots.sh
./install-dots.sh -a
```

## Help for the install-dots.sh script

```
usage: install-dots.sh [-h] [-a] [-t TAGS] [-I] [-F] [-P] [-w] [-W] [-S]

  Install dotfiles from this directory. Also ICONS, FONTS, PACKAGES,
    WALLPAPERS can be installed in the right place.

  -h       Show this help.
  -a       Install all things that this script provides. Specifically:
             (dotfiles[tags:all], icons, fonts, packages, wallpapers[git])
  -t TAGS  Install specific tags, comma separated list.
  -I       [WIP] Install icons. (_icons/install-icons.sh)
  -F       Install fonts. (_fonts/install-fonts.sh)
  -P       [WIP] Install packages specific to the distribution/package manager.
             (_packages/install-packages.sh)
  -w       Install wallpapers shipped with this repository
             (_images/*) in /home/hbery/Pictures directory.
  -W       Install beautiful wallpapers from DistroTube's repository
             into /home/hbery/Pictures directory.
             (https://gitlab.com/dwt1/wallpapers.git)
  -S       [WIP] Install system tweaks. (Outside of /home/hbery directory)

List of available TAGS:
  * all: alacritty awesomewm bash brave dunst firefox git gtk2 gtk3 htop kde latte mypaint nvim pcmanfm plank qtilewm rofi screen screenlayout scripts shell spacefm starship tmux ulauncher urxvt vim vscode xdefaults xfce xterm zsh lynx
  * xfce: xfce plank rofi
  * kde: kde konsole yakuake latte rofi
  * base: sys xdefaults bash shell zsh vim nvim tmux screen git htop starship
  * awesome: awesomewm dunst rofi nitrogen
  * add-gui: mypaint vscode brave spacefm
  * base-gui: screenlayout alacritty xterm urxvt gtk2 gtk3 mpv pcmanfm firefox
  * bspwm: bspwm sxhkd dunst rofi nitrogen
  * scripts: scripts
  * qtile: qtilewm dunst rofi nitrogen
  * custom: what_do_you_want; format `-t custom:dir1,dir2,..`
```

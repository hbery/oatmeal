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
usage: $(basename "$0") [-h] [-a] [-T TAGS] [-I] [-F] [-P] [-w] [-W] [-S]

  Install dotfiles from this directory. Also ICONS, FONTS, PACKAGES,
    WALLPAPERS can be installed in the right place.

  -h       Show this help.
  -a       Install all things that this script provides. Specifically:
             (dotfiles[tags:all], icons, fonts, packages, wallpapers[git])
  -T TAGS  Install specific tags, comma separated list.
  -I       [WIP] Install icons. (_icons/install-icons.sh)
  -F       Install fonts. (_fonts/install-fonts.sh)
  -P       [WIP] Install packages specific to the distribution/package manager.
             (_packages/install-packages.sh)
  -w       Install wallpapers shipped with this repository
             (_images/*) in ${HOME}/Pictures directory.
  -W       Install beautiful wallpapers from DistroTube's repository
             into ${HOME}/Pictures directory. (https://gitlab.com/dwt1/wallpapers.git)
  -S       [WIP] Install system tweaks. (Outside of ${HOME} directory)

List of available TAGS:
all base base-gui scripts add-gui kde xfce qtile awesome bspwm
```

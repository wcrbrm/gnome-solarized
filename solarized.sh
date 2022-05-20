#!/usr/bin/env bash

# Gnome theme CLI switcher - between solarized dark or solarized light
# - Custom theme must be already turned on instead of defaults to work
# - Solarized color scheme for VIM must be installed already

set -e
export keyroot=/org/gnome/terminal/legacy/profiles:
export profile="$(dconf list $keyroot/ | head -n1 | sed 's./..')"

[[ $profile == "" ]] && {
  echo "ERROR: Gnome terminal profile was not detected"
  exit 1
}

[[ $1 == "dump" ]] && {
  echo export keyroot=$keyroot
  echo export profile=$profile
  dconf list $keyroot/$profile/ | while read k; do
    export v=$(dconf read $keyroot/$profile/$k)
    echo dconf write \$keyroot/\$profile/$k \"$v\"
  done
  exit 0
}

[[ $1 == "read" ]] && {
  dconf list $keyroot/$profile/ | while read k; do
    export v=$(dconf read $keyroot/$profile/$k)
    echo $k=$v
  done
  exit 0
}


[[ $1 == "light" ]] && {
  # terminal
  dconf write $keyroot/$profile/background-color "'rgb(253,246,227)'"
  dconf write $keyroot/$profile/foreground-color "'rgb(101,123,131)'"
  dconf write $keyroot/$profile/palette "['rgb(7,54,66)', 'rgb(220,50,47)', 'rgb(133,153,0)', 'rgb(181,137,0)', 'rgb(38,139,210)', 'rgb(211,54,130)', 'rgb(42,161,152)', 'rgb(238,232,213)', 'rgb(0,43,54)', 'rgb(203,75,22)', 'rgb(88,110,117)', 'rgb(101,123,131)', 'rgb(131,148,150)', 'rgb(108,113,196)', 'rgb(147,161,161)', 'rgb(253,246,227)']"
  dconf write $keyroot/$profile/use-theme-colors "false"
  dconf write $keyroot/$profile/use-theme-transparency "false"
  # gedit
  dconf write /org/gnome/gedit/preferences/editor/scheme "'solarized-light'"
  # vim
  [[ -f ~/.vimrc ]] && {
    sed -i '/colorscheme /c\colorscheme solarized' ~/.vimrc
    sed -i '/set background/c\set background=light' ~/.vimrc
  }
  # vimfm
  [[ -f ~/.vifm/vifmrc ]] && {
    sed -i '/colorscheme /c\colorscheme solarized-light' ~/.vifm/vifmrc
  }
  exit 0
}

[[ $1 == "dark" ]] && {
  # terminal
  dconf write $keyroot/$profile/background-color "'rgb(0,43,54)'"
  dconf write $keyroot/$profile/foreground-color "'rgb(131,148,150)'"
  dconf write $keyroot/$profile/palette "['rgb(7,54,66)', 'rgb(220,50,47)', 'rgb(133,153,0)', 'rgb(181,137,0)', 'rgb(38,139,210)', 'rgb(211,54,130)', 'rgb(42,161,152)', 'rgb(238,232,213)', 'rgb(0,43,54)', 'rgb(203,75,22)', 'rgb(88,110,117)', 'rgb(101,123,131)', 'rgb(131,148,150)', 'rgb(108,113,196)', 'rgb(147,161,161)', 'rgb(253,246,227)']"
  dconf write $keyroot/$profile/use-theme-colors "false"
  dconf write $keyroot/$profile/use-theme-transparency "false"
  # gedit
  dconf write /org/gnome/gedit/preferences/editor/scheme "'solarized-dark'"
  # vim
  [[ -f ~/.vimrc ]] && {
    sed -i '/colorscheme /c\colorscheme solarized' ~/.vimrc
    sed -i '/set background/c\set background=dark' ~/.vimrc
  }
  # vifm
  [[ -f ~/.vifm/vifmrc ]] && {
    sed -i '/colorscheme /c\colorscheme solarized-dark' ~/.vifm/vifmrc
  }
  exit 0
}

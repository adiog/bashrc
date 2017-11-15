#!/bin/bash

GNOME_TERMINAL_COLO_PATH=$HOME/.dotfiles/gnome-colors

gnomeVersion="$(expr "$(gnome-terminal.real --version)" : '.* \(.*[.].*[.].*\)$')"
dircolors_checked=false

profiles_path=/org/gnome/terminal/legacy/profiles:
get_theme() {
  profile=$(get_uuid $1)
  profile_path=$profiles_path/$profile

  dconf read $profile_path/palette > $GNOME_TERMINAL_COLO_PATH/$1.palette

  # set foreground, background and highlight color
  # dconf write $profile_path/bold-color "'$SOME_COLOR'"
  dconf read $profile_path/background-color > $GNOME_TERMINAL_COLO_PATH/$1.background-color
  dconf read $profile_path/foreground-color > $GNOME_TERMINAL_COLO_PATH/$1.foreground-color

  # make sure the profile is set to not use theme colors
  dconf read $profile_path/use-theme-colors > $GNOME_TERMINAL_COLO_PATH/$1.use-theme-colors

  # set highlighted color to be different from foreground color
  dconf read $profile_path/bold-color-same-as-fg > $GNOME_TERMINAL_COLO_PATH/$1.bold-color-same-as-fg
}


set_theme() {
  profile=$(get_uuid $1)
  profile_path=$profiles_path/$profile

  dconf write $profile_path/palette "`cat $GNOME_TERMINAL_COLO_PATH/$1.palette`"

  # set foreground, background and highlight color
  dconf write $profile_path/background-color "`cat $GNOME_TERMINAL_COLO_PATH/$1.background-color`"
  dconf write $profile_path/foreground-color "`cat $GNOME_TERMINAL_COLO_PATH/$1.foreground-color`"

  # make sure the profile is set to not use theme colors
  dconf write $profile_path/use-theme-colors "`cat $GNOME_TERMINAL_COLO_PATH/$1.use-theme-colors`"

  # set highlighted color to be different from foreground color
  dconf write $profile_path/bold-color-same-as-fg "`cat $GNOME_TERMINAL_COLO_PATH/$1.bold-color-same-as-fg`"
}


get_uuid() {
  profiles=($(dconf list $profiles_path/ | grep ^: | sed 's/\///g'))
  # Print the UUID linked to the profile name sent in parameter
  local profile_name=$1
  for i in ${!profiles[*]}
    do
      if [[ "$(dconf read $profiles_path/${profiles[i]}/visible-name)" == \
          "'$profile_name'" ]]
        then echo "${profiles[i]}"
        return 0
      fi
    done
  echo "$profile_name"
}

if [[ $1 == "set" ]]; then
  set_theme $2
elif [[ $1 == "get" ]]; then
  get_theme $2
else
  echo "./colo.sh [set|get] gnome-terminal-profile-name"
fi

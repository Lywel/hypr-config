#!/usr/bin/env bash

handle_windowtitlev2 () {
  # Description: emitted when a window title changes.
  # Format: `WINDOWADDRESS,WINDOWTITLE`
  windowaddress=${1%,*}
  windowtitle=${1#*,}

  echo " -> Handling windowtitlev2: $windowtitle (address: 0x$windowaddress)"

  case $windowtitle in
    *"(Bitwarden"*"Password Manager) - Bitwarden"*)
      hyprctl --batch \
        "dispatch togglefloating address:0x$windowaddress;"\
        "dispatch resizewindowpixel exact 20% 54%,address:0x$windowaddress;"\
        "dispatch centerwindow"
      ;;

    "Connexion : comptes Google —"* |\
      "Sign In - Google Accounts — "* |\
      "Sign in - Google Accounts - Helium")
      hyprctl --batch \
        "dispatch togglefloating address:0x$windowaddress;"\
        "dispatch resizewindowpixel exact 25% 54%,address:0x$windowaddress;"\
        "dispatch centerwindow"
      ;;

    "Extension: (MetaMask) - MetaMask — Firefox"*)
      hyprctl --batch \
        "dispatch togglefloating address:0x$windowaddress;"\
        "dispatch resizewindowpixel exact 25% 54%,address:0x$windowaddress;"\
        "dispatch centerwindow"
      ;;

    *) echo " -> No matching title" ;;
  esac
}

handle_fullscreen () {
  is_fullscreen="$1"
  monitor_nb=$(($(hyprctl monitors -j | jq length)+0))

  echo " -> Handling fullscreen: $is_fullscreen on $monitor_nb monitors"

  case $is_fullscreen in
    1)
      show_bar bar-1 false
      show_bar bar-0 $([ $monitor_nb -gt 1 ] && echo true || echo false)
      ;;
    0)
      show_bar bar-0 true
      show_bar bar-1 true
      ;;
  esac
}

show_bar() {
  bar=$1
  show=$2
  is_visible="$(hyprpanel isWindowVisible $bar)"
  if [ $is_visible != $show ]; then
    hyprpanel toggleWindow $bar
  fi
}

handle() {
  # $1 Format: `EVENT>>DATA`
  # example: `workspace>>2`
  
  event=${1%>>*}
  data=${1#*>>}

  echo "event: $event>>$data"

  case $event in
    windowtitlev2) handle_windowtitlev2 "$data";;
    fullscreen) handle_fullscreen "$data";;
#   anyotherevent) handle_otherevent "$data";;
    *) echo " -> unhandled" ;;
  esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done


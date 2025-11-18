#!/bin/bash

# echo 'NOTE: This script will only work if launched via source or .' >&2
# echo -n 'Keyring password: ' >&2
# read -s _UNLOCK_PASSWORD || return
# killall -q -u "$(whoami)" gnome-keyring-daemon
# eval $(echo -n "${_UNLOCK_PASSWORD}" \
#            | gnome-keyring-daemon --daemonize --replace --unlock \
#            | sed -e 's/^/export /')
# unset _UNLOCK_PASSWORD
# echo '' >&2

hyprctl dispatch exec -- dex -as /home/maxime/.config/autostart

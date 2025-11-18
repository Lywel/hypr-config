#! bash

set -xe

yay -Scc

# Without hyprland-meta-git

# yay -Syu --rebuildall --asdeps --sudoloop --noconfirm hyprcursor-git hypridle-git hyprland-qt-support-git hyprlock-git hyprutils-git hyprevents-git hyprland-git hyprland-qtutils-git hyprprop-git hyprwayland-scanner-git hyprgraphics-git hyprland-protocols-git hyprlang-git hyprsunset-git aquamarine-git


# with  hyprland-meta-git

yay -Syu --rebuildall --asdeps --sudoloop --noconfirm hyprland-qt-support-git hyprland-meta-git

hyprpm --verbose update

hyprpm --verbose reload

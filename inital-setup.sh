#!/bin/bash
############################
# This scrip downloads needed packages
############################

if sudo pacman -Qs paru > /dev/null ; then
    echo "paru is installed. You can proceed with the installation"
else
    echo "paru is not installed. Will be installed now!"
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd ..
    clear
fi

################################
#Installation of packages
################################

_needed_packages="fish neovim firefox ttf-jetbrains-mono-nerd \
    hyprpicker-git waybar-git \
dunst nwg-look wf-recorder wlogout wlsunset"

## Hyprland Stuff
paru -S --needed $_needed_packages


################################
# Configuring fish
################################
echo /usr/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/bin/fish
# curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

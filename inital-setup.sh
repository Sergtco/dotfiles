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

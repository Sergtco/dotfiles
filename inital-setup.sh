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

_needed_packages="fish neovim firefox ttf-jetbrains-mono-nerd"
_hypr_packages=" hyprpicker-git waybar-git \
dunst nwg-look wf-recorder wlogout wlsunset \
colord ffmpegthumbnailer gnome-keyring grimblast-git gtk-engine-murrine \
imagemagick kvantum pamixer playerctl polkit-kde-agent qt5-quickcontrols        \
qt5-quickcontrols2 qt5-wayland qt6-wayland swaybg ttf-font-awesome tumbler     \
ttf-jetbrains-mono ttf-icomoon-feather xdg-desktop-portal-hyprland-git xdotool  \
xwaylandvideobridge-cursor-mode-2-git cliphist qt5-imageformats qt5ct"

while true; do
    read -p "Hyprland? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            _needed_packages+=_hypr_packages
        break;;
        [Nn]* ) 
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

## Hyprland Stuff
paru -S --needed $_needed_packages


################################
# Configuring fish
################################
echo /usr/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/bin/fish
# curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

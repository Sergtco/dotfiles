#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files=""    # list of files to symlink in homedir
conf_folders="kitty/ nvim/ fish/ omf/ \
    hypr/ swaylock/ swaync/ waybar/ wlogout\
    wofi/" # list of folders to symlink in homedir

##########
#


#Hyprland
while true; do
    read -p "Hyprland? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            rm -r ~/.config/hypr/hyprland.conf
            ln -s $dir/hyprland.conf ~/.config/hypr/hyprland.conf
        break;;
        [Nn]* ) 
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    # echo "Moving any existing dotfiles from ~ to $olddir"
    # mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.config/$file
done

# move any existing folders in homedir to dotfiles_old directory, then create symlinks 
for folder in $conf_folders; do
    # echo "Moving any existing dotfiles from ~ to $olddir"
    # mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $folder in .config directory."
    ln -s $dir/$folder ~/.config/
done

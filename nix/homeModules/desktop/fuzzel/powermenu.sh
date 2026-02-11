#!/usr/bin/env bash

SELECTION="$(printf "1 - Lock\n2 - Suspend\n3 - Log out\n4 - Reboot\n5 - Hibernate\n6 - Reboot to UEFI\n7 - Hard reboot\n8 - Shutdown" | fuzzel --dmenu -l 8 -p "Power Menu: ")"

case $SELECTION in
	*"Lock")
		loginctl lock-session ${XDG_SESSION_ID-};;
	*"Suspend")
		systemctl suspend;;
	*"Log out")
        niri msg action quit;;
	*"Reboot")
		systemctl reboot;;
	*"Hibernate")
		systemctl hibernate;;
	*"Reboot to UEFI")
		systemctl reboot --firmware-setup;;
	*"Hard reboot")
		pkexec "echo b > /proc/sysrq-trigger";;
	*"Shutdown")
		systemctl poweroff;;
esac

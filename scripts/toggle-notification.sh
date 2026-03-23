#!/usr/bin/env bash
FILE="/tmp/fnott_dnd"

if [[ ! -f "$FILE" ]] || ! grep -Fxq "1" $FILE; then
    notify-send "notifications off"
    sleep 3
    fnottctl pause 
    echo 1 > $FILE
else
    fnottctl unpause 
    notify-send "notifications on"
    echo 0 > $FILE
fi

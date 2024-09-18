#!/bin/bash
mpdconf=/etc/mpd.conf

. "$HOME/.config/mpd-local.conf"
. mpdignore.functions

printf "Ignoring current song: "
mpc -f %file%
mpc current -f %file% >> "$mpdpldir"/.mpdignore.m3u

read -r -p "Do you wish to skip the current song? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
 skip.sh
fi

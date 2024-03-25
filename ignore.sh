#!/bin/bash
mpdconf=/etc/mpd.conf

. mpdignore.functions

getmpdpldir
getmpdconf

printf "Ignoring current song: "
mpc -f %file%
mpc current -f %file% >> "$pldir"/.mpdignore.m3u

read -r -p "Do you wish to skip the current song? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
 skip.sh
fi

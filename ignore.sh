#!/bin/bash
mpdconf=/etc/mpd.conf

if [[ -f "$mpdconf" ]] # defines the location of mpd playlist directory; this is defined in the mpd.conf file found at /etc/mpd.conf by default
 then
   pldir=$(grep -v "^#" "$mpdconf" | grep -v "^$" | grep playlist_directory)
   pldir="${pldir%*\"}"
   pldir="${pldir#*\"}"
   pldir="${pldir%/}"
 else
   pldir="/var/lib/mpd/playlists"  # manually code the location if /etc/mpd.conf doesn't exist.
fi

printf "Ignoring current song: "
mpc -f %file%
mpc current -f %file% >> "$pldir"/.mpdignore.m3u

read -r -p "Do you wish to skip the current song? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
 skip.sh
fi

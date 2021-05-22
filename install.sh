#!/bin/bash
mpdconf=/etc/mpd.conf

if [[ -f "$mpdconf" ]]			# defines the location of your mpd logfile path; this is defined in the mpd.conf file found at /etc/mpd.conf by default
 then
   mpdpass="$(grep -v "^#" "$mpdconf" | grep -v "^$" | grep password | grep control | head -n 1)"
   mpdpass="${mpdpass%*\"}"
   mpdpass="${mpdpass#*\"}"
   mpdpass="${mpdpass%\@*}"
 else
   read -p "What is the mpd controll password?" mpdpass
#   mpdpass="Passwword123"		# manually code the location if /etc/mpd.conf doesn't exist.
fi

cp ./ignore.sh ./skip.sh ./mpdignore.sh /usr/local/sbin

sed -i "s/Passwword123/$mpdpass/g" /usr/local/sbin/skip.sh

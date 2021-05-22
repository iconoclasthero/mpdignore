#!/bin/bash
mpdconf=/etc/mpd.conf
installdir=/usr/local/sbin

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

cp ./ignore.sh ./skip.sh ./mpdignore.sh "$installdir"
chmod +X "$installdir/ignore.sh" "$installdir/skip.sh"

if [[ ! -L "$installdir/skip" ]]; then
 ln -s "$installdir/skip.sh" "$installdir/skip"
fi

if [[ ! -L  "$installdir/ignore" ]]; then
 ln -s "$installdir/ignore.sh" "$installdir/ignore"
fi

sed -i "s/Passwword123/$mpdpass/g" /usr/local/sbin/skip.sh

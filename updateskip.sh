#!/bin/bash

scriptname=$(realpath "$0")

function editscript(){ if [ "$1" = "edit" ] || [ "$1" = "nano" ]; then (/usr/bin/nano "$scriptname"); exit; fi ; }

function pause(){ read -p "$*" ; }

editscript "$1"

if [[ -f "$mpdconf" ]]			# defines the location of your mpd logfile path; this is defined in the mpd.conf file found at /etc/mpd.conf by default
 then
   mpdpass=$(grep -v "^#" "$mpdconf" | grep -v "^$" | grep password | grep control | head -n 1)
   mpdpass="${mpdpass%*\"}"
   mpdpass="${mpdpass#*\"}"
   mpdpass="${mpdpass%\@*}"
 else
   read -p "What is the mpd controll password?" mpdpass
#   mpdpass="Passwword123"		# manually code the location if /etc/mpd.conf doesn't exist.
fi

sudo cp ~/bin/gits/mpdignore/skip.sh /usr/local/sbin/skip.sh
sudo sed -i 's/Passwword123/"$mpdpass"/' /usr/local/sbin/skip.sh
sudo chown root:root /usr/local/sbin/skip.sh
sudo chmod a+x skip.sh

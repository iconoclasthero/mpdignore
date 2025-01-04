#!/bin/bash
mpdconf=/etc/mpd.conf
scriptname=$(realpath "$0")

. mpdignore.functions

getmpdpass

sudo cp ~/bin/gits/mpdignore/skip.sh /usr/local/sbin/skip.sh
sudo sed -i "s/Passwword123/$mpdpass/" /usr/local/sbin/skip.sh
sudo chown root:root /usr/local/sbin/skip.sh
sudo chmod a+x skip.sh

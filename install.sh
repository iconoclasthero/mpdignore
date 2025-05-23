#!/bin/bash
mpdlocal=~/.config/mpd-local.conf
mpdconf=/etc/mpd.conf
installdir=/usr/local/bin

if [[ -f "$mpdlocal" ]]; then
  source "$mpdlocal"
elif [[ -f "$mpdconf" ]]			# defines the location of your mpd logfile path; this is defined in the mpd.conf file found at /etc/mpd.conf by default
 then
   mpdpass="$(grep -v "^#" "$mpdconf" | grep -v "^$" | grep password | grep control | head -n 1)"
   mpdpass="${mpdpass%*\"}"
   mpdpass="${mpdpass#*\"}"
   mpdpass="${mpdpass%\@*}"
 else
   read -p "What is the mpd controll password?" mpdpass
#   mpdpass="Passwword123"		# manually code the location if /etc/mpd.conf doesn't exist.
fi

rm "$installdir/ignore.sh" "$installdir/skip.sh" "$installdir/mpdignore.sh"
for i in ignore.sh skip.sh mpdignore.sh; do
  ln -sf "/home/$SUDO_USER/bin/gits/mpdignore/$i" "$installdir/"
done

#chown root:root "$installdir/ignore.sh" "$installdir/skip.sh" "$installdir/mpdignore.sh"
#chmod +X "$installdir/ignore.sh" "$installdir/skip.sh" "$installdir/mpdignore.sh"

if [[ ! -L "$installdir/skip" ]]; then
 ln -s "$installdir/skip.sh" "$installdir/skip"
fi

if [[ ! -L  "$installdir/ignore" ]]; then
 ln -s "$installdir/ignore.sh" "$installdir/ignore"
fi

#sed -i "s/Passwword123/$mpdpass/g" /usr/local/bin/skip.sh

ln -sf "/home/$SUDO_USER/bin/gits/mpdignore/mpdignore.service" /etc/systemd/system/
ln -sf "/home/$SUDO_USER/bin/gits/mpdignore/mpdignore.path" /etc/systemd/system/
#chown root:root /etc/systemd/system/mpdignore.path /etc/systemd/system/mpdignore.service
systemctl daemon-reload
systemctl enable mpdignore.path && systemctl start mpdignore.path && systemctl status mpdignore.path
systemctl enable mpdignore.service && systemctl status mpdignore.service

#!/bin/bash

#pldir="/var/lib/mpd/playlists"          # defines playlist directory; default = /var/lib/mpd/playlists
watchfile=".mpdignore.m3u"		# defines the watched playlist; default = .mpdignore.m3u
mpdconf="/etc/mpd.conf"			# defines mpd.conf location; default = /etc/mpd.conf
mpduser="mpd"				# defines the user mpd service runs as; default = mpd
mpdgroup="media"			# defines the group mpd service runs as; default = media
ignoredm3u="mpdignored.m3u"		# defines the playlist of songs ignored by mpdignore; default = mpdignored.m3u

watchfile="$pldir/$watchfile"		# sets full path of watchfile
ignoredm3u="$pldir/$ignoredm3u"		# sets full path of ignoredm3u

if [[ -f "$mpdconf" ]]			# defines the location of your mpd music directory; this is defined in the mpd.conf file found at /etc/mpd.conf by default
 then
   musicdir="$(grep -v "^#" "$mpdconf" | grep -v "^$" | grep music_directory)"
   musicdir="${musicdir%*\"}"
   musicdir="${musicdir#*\"}"
   musicdir="${musicdir%/}"
 else
   musicdir="/library/music"		# manually code the location if /etc/mpd.conf doesn't exist.
fi

if [[ -f "$pldir" ]]			# defines the location of your mpd music directory; this is defined in the mpd.conf file found at /etc/mpd.conf by default
 then
   pldir="$(grep -v "^#" "$mpdconf" | grep -v "^$" | grep playlist_directory)"
   pldir="${pldir%*\"}"
   pldir="${pldir#*\"}"
   pldir="${pldir%/}"
 else
   pldir="/var/lib/mpd/playlists"		# manually code the location if /etc/mpd.conf doesn't exist.
fi

while read -r line
 do
  song="${line##*/}"
  songdir="${line%/*}"
  ignoredir="$musicdir/$songdir"
  if [[ -f "$ignoredir"/.mpdignore ]]
   then
    cp "$ignoredir"/.mpdignore "$ignoredir"/.mpdignore~
   fi
  printf '%s\n' "$song" "# added on `date`" >> "$ignoredir"/.mpdignore
  printf '%s has been added to .mpdignore in %s\n' "$song" "$ignoredir"
  printf '%s\n' "$line" >> "$ignoredm3u"
 done < "$watchfile"

echo "#last run `date`" >> "$ignoredm3u"
> "$watchfile"										# clears the watchfile after run
chmod g+w "$ignoredir"/.mpdignore "$ignoredm3u" "$watchfile"				# grants group access to the watchfile, ignoredm3u, and the created/updated .mpdignore file
chown "$mpduser":"$mpdgroup" "$ignoredir"/.mpdignore "$ignoredm3u" "$watchfile"		# changes ownership of the above files to mpd and its goup (e.g., so the ignored playlist is readable by mpd)



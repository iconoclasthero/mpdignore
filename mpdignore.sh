#!/bin/bash

scriptname=$(realpath "$0")

function editscript(){ if [ "$1" = "edit" ] || [ "$1" = "nano" ]; then (/usr/bin/nano "$scriptname"); exit; fi ; }

editscript "$1"

####################################################
#This block is now defined in mpdignore.functions
#pldir="/var/lib/mpd/playlists"		# defines playlist directory; default = /var/lib/mpd/playlists
#watchfile=".mpdignore.m3u"		# defines the watched playlist; default = .mpdignore.m3u
#mpdconf="/etc/mpd.conf"		# defines mpd.conf location; default = /etc/mpd.conf
#mpduser="mpd"				# defines the user mpd service runs as; default = mpd
#mpdgroup="media"			# defines the group mpd service runs as; default = media
#ignoredm3u="mpdignored.m3u"		# defines the playlist of songs ignored by mpdignore; default = mpdignored.m3u
####################################################


. mpdignore.functions

####################################################
#This block is now defined in mpdignore.functions
#if [[ -f "$mpdconf" ]]			# defines the location of your mpd music directory; this is defined in the mpd.conf file found at /etc/mpd.conf by default
# then
#   musicdir=$(grep -v "^#" "$mpdconf" | grep -v "^$" | grep music_directory)
#   musicdir="${musicdir%*\"}"
#   musicdir="${musicdir#*\"}"
#   musicdir="${musicdir%/}"
# else
#   musicdir="/library/music"		# manually code the location if /etc/mpd.conf doesn't exist.
#fi

getmpdmusicdir

####################################################
#This block is now defined in mpdignore.functions
#if [[ -f "$mpdconf" ]]			# defines the location of your mpd playlist directory; this is defined in the mpd.conf file found at /etc/mpd.conf by default
# then
#   pldir=$(grep -v "^#" "$mpdconf" | grep -v "^$" | grep playlist_directory)
#   pldir="${pldir%*\"}"
#   pldir="${pldir#*\"}"
#   pldir="${pldir%/}"
# else
#   pldir="/var/lib/mpd/playlists"	# manually code the location if /etc/mpd.conf doesn't exist.
#fi

getmpdpldir

####################################################
#This block is now defined in mpdignore.functions
#if [[ -f "$mpdconf" ]]			# defines the location of your mpd logfile path; this is defined in the mpd.conf file found at /etc/mpd.conf by default
# then
#   mpdlog=$(grep -v "^#" "$mpdconf" | grep -v "^$" | grep log_file)
#   mpdlog="${mpdlog%*\"}"
#   mpdlog="${mpdlog#*\"}"
#   mpdlog="${mpdlog%/}"
# else
#   mpdlog="/var/log/mpd/mpd.log"	# manually code the location if /etc/mpd.conf doesn't exist.
#fi

getmpdlog

watchpath="$pldir/$watchfile"		# sets full path of watchfile
ignoredpath="$pldir/$ignoredm3u"        # sets full path of ignoredm3u

while read -r line
 do
  song="${line##*/}"
  songdir="${line%/*}"
  ignoredir="$musicdir/$songdir"
  if [[ -f "$ignoredir"/.mpdignore ]]
     then
        cp "$ignoredir"/.mpdignore "$ignoredir"/.mpdignore~
  fi
											#mpd does not recognize file names with square brackets in .mpdignore files and the
  if [[ "$song" =~ \[ ]] || [[ "$song" =~ \] ]]						#individual square bracket characters must be escaped such that they will be recognized
     then
        song=$(sed -e 's/\\\]/\]/g' -e 's/\\\[/\[/g' -e 's/\[/\\\[/g' -e 's/\]/\\\]/g' <<< "$song" )
  fi

  printf "%s\n# added on %s\n" "$song" "$(date)" >> "$ignoredir"/.mpdignore
  printf '%s has been added to .mpdignore in %s\n' "$song" "$ignoredir"
  printf '%s\n' "$line" >> "$ignoredpath"
  printf '%s\n' "$(date '+%b %d %H:%M : player: ignored ')\"$line\"" | cat >> "$mpdlog"
 done < "$watchpath"

echo "#last run $(date)" >> "$ignoredpath"

: > "$watchpath"									# clears the watchfile after run

chmod g+w "$ignoredir"/.mpdignore "$ignoredpath" "$watchpath"				# grants group access to the watchfile, ignoredm3u, and the created/updated .mpdignore file
chown "$mpduser":"$mpdgroup" "$ignoredir"/.mpdignore "$ignoredpath" "$watchpath"		# changes ownership of the above files to mpd and its goup (e.g., so the ignored playlist is readable by mpd)




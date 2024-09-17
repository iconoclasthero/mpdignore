#!/bin/bash
# NB: This script requires that the user have access to edit /var/log/mpd/mpd.log which means modifying the permissions/ownership

#logsong() {
#   i=$(date '+%b %d %H:%M : player: skipped ')
#   j=$(mpcp current -f %file%)
#   printf '%s\"%s\"\n' "$i" "$j" | cat >> "$mpdlog"
#}

#mpcp() {
#  mpc -P "$mpdpass" -h "$mpdhost" "$@"
#}

#if [[ -f "$mpdconf" ]] # defines the location of your mpd logfile path; this is defined in the mpd.conf file found at  /etc/mpd.conf by default
# then
#   mpdlog=$(grep -v "^#" "$mpdconf" | grep -v "^$" | grep log_file)
#   mpdlog="${mpdlog%*\"}"
#   mpdlog="${mpdlog#*\"}"
#   mpdlog="${mpdlog%/}"
# else
#   mpdlog="/var/log/mpd/mpd.log"  # manually code the location if /etc/mpd.conf doesn't exist.
#fi

. "$XDG_CONFIG_HOME/mpd-local.conf"
. mpdignore.functions
logsong "skipped"
mpcp next

#skipped="$(mpc -P "$mpdpass" -h "$mpdhost" current -f "%title%")"
#queued="$(mpc -P "$mpdpass" -h "$mpdhost" queued -f "%title%")"
#qartist="$(mpc -P "$mpdpass" -h "$mpdhost" queued -f "%artist%")"
#notify-send -i audio-x-generic "Song Skipped!" "<b>Next song:</b> $queued by $qartist"

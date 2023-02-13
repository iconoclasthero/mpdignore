#!/bin/bash
# NB: This script requires that the user have access to edit /var/log/mpd/mpd.log which means modifying the permissions/ownership

mpdconf="/etc/mpd.conf"

logsong() {
   i=$(date '+%b %d %H:%M : player: skipped ')
   j=$(mpcp current -f %file%)
   printf '%s\"%s\"\n' "$i" "$j" | cat >> "$mpdlog"
}

mpcp() {
    command mpc -P Passwword123 "$@"
}

if [[ -f "$mpdconf" ]]	# defines the location of your mpd logfile path; this is defined in the mpd.conf file found at /etc/mpd.conf by default
 then
   mpdlog="$(grep -v "^#" "$mpdconf" | grep -v "^$" | grep log_file)"
   mpdlog="${mpdlog%*\"}"
   mpdlog="${mpdlog#*\"}"
   mpdlog="${mpdlog%/}"
 else
   mpdlog="/var/log/mpd/mpd.log"  # manually code the location if /etc/mpd.conf doesn't exist.
fi

logsong
mpcp next

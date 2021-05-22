#!/bin/bash
logsong() {
   i=$(date '+%b %d %H:%M : player: skipped ')
   j=$(mpcp current -f %file%)
   printf '%s\n' "$i\"$j\"" | cat >> /var/log/mpd/mpd.log
}

mpcp() {
    command mpc -P Passwword123 "$@"
}


logsong
mpcp next

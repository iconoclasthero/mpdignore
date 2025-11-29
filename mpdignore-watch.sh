#!/usr/bin/bash
trap 'printf "\n[warn] Exiting watcher\n"; exit 0' SIGINT SIGTERM
printf '[info] mpdignore watcher started\n'

mpdpldir="/library/music/mpdplaylists"

while (( "$#" )); do
  [[ "$1" = --watch-file=* ]] && { watchfile+=( "${1#*=}" ); shift; continue; }
  [[ "$1" = --watch-path=* ]] && { watchpath+=( "${1#*=}" ); shift; continue; }
  [[ "$1" = --config=*     ]] && { config="${1#*=}"        ; shift; continue; }
  [[ "$1" = --group=*      ]] && { mpdgroup="${1#*=}"      ; shift; continue; }
  { printf 'Ignoring unknowin argument: %s\n' "$1"         ; shift; continue; }
done

: "${mpdgroup:=media}"
: "${mpduser:=mpd}"

## this needs to be built out to have the same flexibility this used to have but for now...
(( "${#watchfile[@]}" )) &&
  for file in "${watchfile[@]}"; do
    watchpath+=( "$mpdpldir/$file" )
  done

if (( "${#watchpath[@]}" == 0)); then
  printf '[error] No paths to watch. (exit)\n' >&2
  exit 1
fi

mpdignoresh="/usr/local/bin/mpdignore.sh"

[[ ! -e "$mpdignoresh" ]] &&
  { printf '[error] Unable to find excutable script to launch:\n  %s\n(exit 1)\n' "$mpdignoresh"; exit 1; }

printf '[info] Watching paths:\n'
printf '[info]  %s\n' "${watchpath[@]}"
#printf 'Launching %s\n' "$mpdignoresh"

while (( try < 5 )); do

  ## make sure the files exist so that innotifywait doesn't shit the bed if they do not exit
  ## the perms and such should probably only be done in the script, but for now...
  for watched in "${watchpath[@]}"; do
    [[ ! -f "$watched" ]] && touch "$watched" && printf '[info] Touched missing file: %s\n' "$watched"
    (( verbose )) && readarray -t statout < <(stat "$watched")
    (( verbose )) && printf '[verbose] stat %s:\n' "$watched"
    (( verbose )) && printf '[verbose] %s\n' "${statout[@]}"
    read G U a < <(stat -c %G\ %U\ %a "$watched")
#   [[ "$G" != "$mpdgroup" ]] && chgrp "$mpdgroup" "$watched" && printf '[info] chgrp %s %s\n' "$mpdgroup" "$watched"
    [[ "$U" != "$mpduser"  ]] && chown "$mpduser" "$watched"  && printf '[info] chown %s %s\n' "$mpduser" "$watched"
    [[ "$a" != 66?         ]] && chmod ug+w "$watched"        && printf '[info] chmod ug+w $s\n' "$watched"
  done

  sleep 1

  while read -r modified event; do
    printf '[info] Change detected: %s on %s\n' "$event" "$modified"
    if [[ -s "$modified" ]]; then
      printf '[info] modified=%s\n' "$modified"
      printf '[info] Calling: %s --config="%s" --watch-path="%s"\n' "$mpdignoresh" "${config:-<null>}" "$modified"
      "$mpdignoresh" --config="$config" --watch-path="$modified"
    else
      printf '[warn] Not calling: %s --watchpath="%s"\n' "$mpdignoresh" "$modified"
      printf '[warn] %s is empty\n' "$modified"
    fi
  done < <(inotifywait -m -e close_write "${watchpath[@]}")

  printf '[error] inotifywait crashed, restarting watcher. Try %s.\n' "$(( try++ ))"
done


exit

## alternate idea for how to use inotifywait create:
## use special directories and only have one file in them that matters OR watch the files but only fire the
## script if the file that changed was the one we want to monitor
watchdirs=(/var/www/cgi-bin /library/music/mpdplaylists)
inotifywait -m -e create,close_write "${watchdirs[@]}" | while read -r path event file; do
  if [[ "$file" == ".mpdignore.m3u" ]]; then
    /usr/local/bin/mpdignore.sh
  fi
done


#!/bin/bash

scriptname=$(realpath "$0")

. /usr/local/bin/editscript
. mpdignore.functions

[[ ! "$musicdir" ]] && getmpdmusicdir

[[ ! "$mpdpldir" ]] && getmpdpldir

[[ ! "$mpdlog" ]] && getmpdlog

watchpath="$mpdpldir/$watchfile"		   # sets full path of watchfile
ignoredpath="$mpdpldir/$ignoredm3u"        # sets full path of ignoredm3u

while read -r line; do
  song="${line##*/}"
  songdir="${line%/*}"
  ignoredir="$musicdir/$songdir"
  if [[ -f "$ignoredir"/.mpdignore ]]; then
    cp "$ignoredir"/.mpdignore "$ignoredir"/.mpdignore~
  fi

if [[ "$song" =~ \[ ]] || [[ "$song" =~ \] ]] || [[ "$song" =~ \\ ]]; then
  song=$(echo "$song" |  -e 's/\\\([^\\]\)/\\\\\1/g' sed -e 's/\[/\\[/g' -e 's/\]/\\]/g')
fi
  printf "%s\n# added on %s\n" "$song" "$(date)" >> "$ignoredir"/.mpdignore
  printf '%s has been added to .mpdignore in %s\n' "$song" "$ignoredir"
  printf '%s\n' "$line" >> "$ignoredpath"
  printf '%s\n' "$(date '+%b %d %H:%M : player: ignored ')\"$line\"" | cat >> "$mpdlog"
done < "$watchpath"

printf '#last run %s\n' "$(date)" >> "$ignoredpath"

#: > "$watchpath"									# clears the watchfile after run
#
#chmod g+w "$ignoredir"/.mpdignore "$ignoredpath" "$watchpath"				# grants group access to the watchfile, ignoredm3u, and the created/updated .mpdignore file
#chown "$mpduser":"$mpdgroup" "$ignoredir"/.mpdignore "$ignoredpath" "$watchpath"		# changes ownership of the above files to mpd and its goup (e.g., so the ignored playlist is readable by mpd)

rm "$watchpath"


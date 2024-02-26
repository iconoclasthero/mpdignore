#!/bin/bash
bold=$(tput bold)
normal=$(tput sgr0)

scriptname=$(realpath "$0")

function editscript(){ if [ "$1" = "edit" ] || [ "$1" = "nano" ]; then (/usr/bin/nano "$scriptname"); exit; fi ; }

function pause(){ read -p "$*" ; }

editscript "$1"


i="$1"

re='^[0-9]+$'
re=^[0-9]+$

#echo "i=$i"


clarguments() {
    if (("$#" == "0")); then
	printf 'Scanning and removing songs after %s seconds.\n' "$duration"
        printf 'Default number of steps is %s.\n' "$steps"
    fi

    while (( "$#" )); do
      case "$1" in
	-c) gum choose --no-limit "Playlist Position" "Song Title" "Artist" "Album Title" "Track Duration" > /tmp/pl.choice
#        -t) case "$2" in
#             ''|*[!0-9]*) ;;
#             *) if (("$2" <=90)) && (("$2" > 0)); then duration="$2" ; printf 'Scanning and removing songs after %s seconds' "$duration"; else printf '\n' "Error:  value for duration must be between 0-90 seconds"; fi;;
#            esac
#            ;;
#        -s) case "$2" in
#             ''|*[!0-9]*) ;;
#             *) if (("$2" > 0)) && (("$2" <= 60)); then steps="$2" ; printf '\nSetting steps to %s' "$steps" ; incr=$(( 100/steps )) ; else printf '%s\n' "Error:  value for number of steps must be between 1-60 steps" ; fi ;;
#            esac
#            ;;
      esac
      shift
    done
    printf '\n'
}


clarguments "$@"

if [ -n "$i" ]
   then
#      if ! [[ "$i" =~ "$re" ]]
      if ! [[ "$i" =~ ^[0-9]+$ ]]
         then
            offset=10
            echo "Input not a number; using 10 by default."
      elif [[ "$i" -le 100 ]] && [[ "$i" -gt 0 ]]
         then
            offset="$i"
      else
            printf "Input not a valid number between 1-100; using 10 by default."
      fi
else
   offset="10"
fi


current="$(/usr/bin/mpc current)"
plpos="$( /usr/bin/mpc current -f %position% )"

headoffset="$offset"
tailoffset="$offset"

#printf "\nOffset is ±%s, unless at either end of the playlist.\n\n" "$offset"
mpc current -f "\n%title% on %album% by %artist%" && mpc
printf "\n"

if [[ $(("$plpos" - "$offset")) -le 0 ]]
  then tailoffset="$plpos"
  printf "%s<< Start of Playlist >>%s\n" "$bold" "$normal"
fi

mpc playlist -f '%position% %title% by %artist%' | grep --color=always -C"$offset" -Fx "$(mpc current -f '%position% %title% by %artist%')"

plnext="$(/usr/bin/mpc queued -f %position%)"
printf "\n%sNext up: %s" "$bold" "$normal"

/usr/bin/mpc queued -f "(%position%) %title% by %artist% on %album%.\n"


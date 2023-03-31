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

ignore() {
if [ -z "${i:+x}" ]
   then
      offset=10
      echo "offset=$offset from first test"
elif ! [[ "$i" =~ "$re" ]]
   then
      offset=10
      echo "Input not a valid number between 1-100; using 10 by default." >&2
elif [[ "$i" -le 100 ]] && [[ "$i" -gt 0 ]]
   then
      offset="$i"
else
      offset="10"
      echo "Input not a valid number beterrn 1-100, using 10 by default."
fi
}

ignore2() {
if [ -n "$i" ]
   then
#      if ! [[ "$i" =~ "$re" ]]
      if ! [[ "$i" =~ ^[0-9]+$ ]]
         then
            offset=10
            echo "Input not a number; using 10 by default." >&2
#            echo "Input not a valid number between 1-100; using 10 by default." >&2
      elif [[ "$i" -le 100 ]] && [[ "$i" -gt 0 ]]
         then
#            printf "i is 1<i<100"
            offset="$i"
      else
            printf "Input not a valid number between 1-100; using 10 by default."
      fi
else
   offset="10"
#   echo "Nothing supplied; offset defaults is 10."
fi
}

if [ -n "$i" ]
   then
#      if ! [[ "$i" =~ "$re" ]]
      if ! [[ "$i" =~ ^[0-9]+$ ]]
         then
            offset=10
            echo "Input not a number; using 10 by default."
#            echo "Input not a valid number between 1-100; using 10 by default." >&2
      elif [[ "$i" -le 100 ]] && [[ "$i" -gt 0 ]]
         then
#            printf "i is 1<i<100"
            offset="$i"
      else
            printf "Input not a valid number between 1-100; using 10 by default."
      fi
else
   offset="10"
#   echo "Nothing supplied; offset defaults is 10."
fi






current="$(/usr/bin/mpc current)"
plpos="$( /usr/bin/mpc current -f %position% )"

headoffset="$offset"
tailoffset="$offset"

#printf "\nOffset is ±%s, unless at either end of the playlist.\n\n" "$offset"
mpc current -f "\n%title% on %album% by %artist%" && mpc
printf "\n"

if [[ $(("$plpos" - "$offset")) -le 0 ]]; then tailoffset="$plpos"; printf "%s<< Start of Playlist >>%s\n" "$bold" "$normal"; 
fi

#mpc playlist | head -$(("$plpos" -1)) |tail +$(("$plpos" - "$tailoffset"))
#printf "%s(%s) %s%s\n" "$bold" "$plpos" "$current" "$normal" # "$(mpc current -f %file%)"
##mpc current -f %file%
#mpc playlist | head -$(("$plpos" + "$offset"))|tail +$(("$plpos" +1))

mpc playlist -f '%position% %title% by %artist%' | grep --color=auto -C"$offset" -Fx "$(mpc current -f '%position% %title% by %artist%')"

plnext="$(/usr/bin/mpc queued -f %position%)"
printf "\n%sNext up: %s" "$bold" "$normal"

/usr/bin/mpc queued -f "(%position%) %title% by %artist% on %album%.\n"


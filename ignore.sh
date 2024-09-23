#!/bin/bash
shopt -s extglob
mpdconf=/etc/mpd.conf

. "$XDG_CONFIG_HOME"/mpd-local.conf || . "$HOME/.config/mpd-local.conf"
. mpdignore.functions

printf "Ignoring current song: "
mpc -f %file%

[[ "$mpdpldir" =~ \  ]] && mpdpldir="${mpdpldir// /\\ }"


if [[ "$mpdhost" = @(localhost|127.0.0.1) ]]; then
  mpc current -f %file% >> "$mpdpldir"/.mpdignore.m3u
else
  ignored=$(mpc current -f %file%)
  ignorecmd=$(printf 'echo "%s"|tee -a %s' "$ignored" "$mpdpldir/.mpdignore.m3u")
#  ssh -p"$sshport" "$mpdhost" sh -c 'printf '%s\n' "$0"|tee -a "$1"/.mpdignore.m3u' "$ignored" "$mpdpldir"
  ssh -p"$sshport" "$mpdhost" "$ignorecmd"
fi

read -r -p "Do you wish to skip the current song? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
 skip.sh
fi

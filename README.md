# mpdignore
What does this do? This is a repo of mpd stuff that started with a system service that monitors a playlist which is added to by the cli command ignore which basically does
`mpc current -f %file% >> "$pldir"/.mpdignore.m3u`
The system service keeps an eye on that playlist and then scrapes that playlist, saves it to another playlist, and then adds the file to the .mpdignore file within the album directory.

I really don't think anyone should be using this as-is, but if it helps inspire someone, great.  If you put together something better than what I have, please let me know.

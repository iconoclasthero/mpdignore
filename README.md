# mpdignore
This is a repository of mpd-related scripts that started as system service to ignore reviled or otherwise unwated songs (e.g., the 53 live/bootleg copies of `Grateful Dead -- * - *Space*flac` in my collection) by creating a [.mpdignore file](https://mpd.readthedocs.io/en/latest/user.html#the-music-directory-and-the-database:~:text=mpdignore) in the song's directory (e.g., `/library/music/artist/album (YYYY)` if so organized) so that mpd won't ever force you to listen to it again.  (MPD removes it from it's library but leaves the file alone so if you want to listen to a _complete_ Grateful Dead bootleg _with_ "Space" wtih VLC because you're so fucking baked it seems like a good idea, you ostensibly could.)

When the user choses to ignore the current mpd recording (mpd may be playing or paused) by `$ ignore` the the song path is recorded to a playlist: `mpc current -f %file% >> "$pldir"/.mpdignore.m3u` .
mpdignore is designed so that mpdignore.path monitors the first playlist, i.e., `/path/to/mpd/playlists/.mpdignore.m3u` by default.  When song paths are added to this playlist (e.g., by calling `$ ignore` while mpd is playing a reviled song), mpdignore.service scrapes this file, does the ignoring, and empties the playlist (as such, .mpdignore.m3u should normally be empty if the mpdignore working properly).  You have the option to skip the currently-playing song.  

#### NB: *This is set up to log to /var/log/mpd/mpd.log (or the log file in mpd.conf) without locking the log.  Max Kellerman/cirrus, #mpd, was quite insistent that touching "his" log file was a problem, especially w/o a lock—though of course he offered no substantive or constructive advice on how to address.  I haven't had an issue in several years — also it's a fucking mpd log file so who really fucking cares if it's corrupted—I don't; YMMV and you're totally on your own here.*
Logging example, line 1 comes from mpd, line 2 comes from skip.sh in this repo: 
```
Mar 25 11:46 : player: played "B.B. King/B.B. King -- King of the Blues (1992) (mp3)/B.B. King -- 03-08 - Niji Baby.mp3"
Mar 25 11:48 : player: skipped "Van Morrison/Van Morrison, Lonnie Donegan & Chris Barber -- The Skiffle Sessions: Live in Belfast (2000)/Van Morrison, Lonnie Donegan & Chris Barber -- 03 - Goin' Home.flac"
```

The second playlist, `/path/to/mpd/playlists/mpdgnored.m3u` keeps a running list of all such reviled songs that have been ignored so that one could e.g., use the playlist to torture your favorite Panamanian dictator ousted by your favorite American imperialist president—or you could just go back and check to see what files you've ignored in the event you wish to e.g., verify what's been added.  (It's a feature I've NEVER used despite thinking I might.)

### I really don't think anyone should be using this as-is, but if it helps inspire someone, great.  If you put together something better than what I have, please let me know.


The rest of the shit in this repo is just stuff I don't really have a better place for and they're all mpd related.  Someday I'll probably _never_ get around to organizing it better since I'm outta fucks to give...


+5                       Increase vol 5%
-5                       Decrease vol 5%
ignore                   symlink to `ignore.sh`
ignore.sh                ignores the current song; logs to `$mpdlog`
install.sh~              Do not use, u-x removed.
list.mpdignores          list all entries from .mpdignore files in the library
mpdignore.functions      shared functions and variable definitions for mpdignore
mpdignore.nfo            an original .nfo file for how this shit was designed so i can refer back to it
mpdignore.path           systemd path file to watch the watchpath playlist (e.g., `/library/music/mpd playlists/.mpdignore.m3u`)
mpdignore.service        systemd service file that calls mpdignore.sh when watchpath playlist is modified
mpdignore.sh             the script that does the actual processing of the song to ignore it, create `.mpdignore`, log, etc.
mpdignore.sh~            a backup copy of the above
playlist                 a playlist script that does some shit...and will eventually be able to ignore non-playing files.
playlist~                a backup copy of the above
README.md                < duh >
skip                     symlink to `skip.sh`
skip.sh                  the script to do the skipping and log it to `$mpdlog`
'snippet: add missed'    no fucking clue what this is
stats                    record current stats for `$musicdir`
updateskip.sh            DO NOT USE until fixed, u-x removed:  this is supposed to update a hard-coded password into skip.sh from `$mpdconf`





# mpdignore
This is a repository of mpd-related scripts that started as system service to ignore reviled or otherwise unwated songs (e.g., the 53 live/bootleg copies of `Grateful Dead -- * - *Space*flac` in my collection) by creating a [.mpdignore file](https://mpd.readthedocs.io/en/latest/user.html#the-music-directory-and-the-database:~:text=mpdignore) in the song's directory (e.g., `/library/music/artist/album (YYYY)` if so organized) so that mpd won't ever force you to listen to it again.  (MPD removes it from it's library but leaves the file alone so if you want to listen to a _complete_ Grateful Dead bootleg _with_ "Space" wtih VLC because you're so fucking baked it seems like a good idea, you ostensibly could.)

When the user choses to ignore the current mpd recording (mpd may be playing or paused) by `$ ignore` the the song path is recorded to a playlist: `mpc current -f %file% >> "$pldir"/.mpdignore.m3u` .
mpdignore is designed so that mpdignore.path monitors the first playlist, i.e., `/path/to/mpd/playlists/.mpdignore.m3u` by default.  When song paths are added to this playlist (e.g., by calling `$ ignore` while mpd is playing a reviled song), mpdignore.service scrapes this file, does the ignoring, and empties the playlist (as such, .mpdignore.m3u should normally be empty if the mpdignore working properly).  You have the option to skip the currently-playing song.  

### NB: *This is set up to log to /var/log/mpd/mpd.log (or the log file in mpd.conf) and there is no file lock.  Max Kellerman/cirrus, #mpd, was quite insistent that touching "his" log file was a problem, especially w/o a lock—though of course he offered no substantive or constructive advice on how to address.  I haven't had an issue in several years — also it's a fucking mpd log file so who really fucking cares if it's corrupted—I don't; YMMV and you're totally on your own here.*

The second playlist, `/path/to/mpd/playlists/mpdgnored.m3u` keeps a running list of all such reviled songs that have been ignored so that one could e.g., use the playlist to torture your favorite Panamanian dictator ousted by your favorite American imperialist president—or you could just go back and check to see what files you've ignored in the event you wish to e.g., verify what's been added.  (It's a feature I've NEVER used despite thinking I might.)

### I really don't think anyone should be using this as-is, but if it helps inspire someone, great.  If you put together something better than what I have, please let me know.


The rest of the shit in this repo is just stuff I don't really have a better place for and they're all mpd related.  Someday I'll probably _never_ get around to organizing it better since I'm outta fucks to give...

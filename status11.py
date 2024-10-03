#!/usr/bin/env python3

import mpd
import os
import configparser


config_file = os.path.expanduser('~/.config/mpd-local.conf')

# Read the configuration file
config = configparser.ConfigParser()
config.read(config_file)

# Get the mpdhost and mpdport from the config file
mpdhost = config.get('DEFAULT', 'mpdhost')
mpdport = config.getint('DEFAULT', 'mpdport')

# Connect to the MPD server using the values from the config file
client = mpd.MPDClient()
client.connect(mpdhost, mpdport)

# Escape single quotes in strings
def escape_quotes(string):
    return string.replace("'", "'\\''") if string else ""

# Get current song and next song details from MPD
status = client.status()
currentsong = client.currentsong()

# Extract variables similar to your existing bash variables
state = status.get("state", "")


client = mpd.MPDClient()
client.connect("ssh.iconoclasthero.com", 6600)

# Escape single quotes in strings
def escape_quotes(string):
    return string.replace("'", "'\\''") if string else ""

# Get current song and next song details from MPD
status = client.status()
currentsong = client.currentsong()

# Extract variables similar to your existing bash variables
state = status.get("state", "")
song_position = status.get("song", "")
song_length = status.get("playlistlength", "")
elapsed = status.get("elapsed", "")
total_time = status.get("duration", "")
percent_time = (float(elapsed) / float(total_time) * 100) if elapsed and total_time else ""
filepath = escape_quotes(currentsong.get("file", ""))
title = escape_quotes(currentsong.get("title", ""))
artist = escape_quotes(currentsong.get("artist", ""))
album_artist = escape_quotes(currentsong.get("albumartist", ""))
album = escape_quotes(currentsong.get("album", ""))
year = status.get("date", "")
volume = status.get("volume", "")
repeat = status.get("repeat", "")
single = status.get("single", "")
random = status.get("random", "")
consume = status.get("consume", "")
disc = escape_quotes(currentsong.get("disc", ""))
genre = escape_quotes(currentsong.get("genre", ""))
track = escape_quotes(currentsong.get("track", ""))
mb_artistid = currentsong.get("musicbrainz_artistid", "")
mb_albumid = currentsong.get("musicbrainz_albumid", "")
mb_trackid = currentsong.get("musicbrainz_trackid", "")
mb_reltrackid = currentsong.get("musicbrainz_releasetrackid", "")
comment = escape_quotes(currentsong.get("comment", ""))
performer = escape_quotes(currentsong.get("performer", ""))
date = escape_quotes(currentsong.get("date", ""))  # Escape since it's a text field

# Get the next song's details
nextsongid = status.get("nextsongid", "")
nextsong = client.playlistid(nextsongid)[0] if nextsongid else {}

# Extract the next song details and create new variables for them
next_filepath = escape_quotes(nextsong.get("file", ""))
next_title = escape_quotes(nextsong.get("title", ""))
next_artist = escape_quotes(nextsong.get("artist", ""))
next_album_artist = escape_quotes(nextsong.get("albumartist", ""))
next_album = escape_quotes(nextsong.get("album", ""))
next_disc = escape_quotes(nextsong.get("disc", ""))
next_genre = escape_quotes(nextsong.get("genre", ""))
next_track = escape_quotes(nextsong.get("track", ""))
next_mb_artistid = nextsong.get("musicbrainz_artistid", "")
next_mb_albumid = nextsong.get("musicbrainz_albumid", "")
next_mb_trackid = nextsong.get("musicbrainz_trackid", "")
next_mb_reltrackid = nextsong.get("musicbrainz_releasetrackid", "")
next_comment = escape_quotes(nextsong.get("comment", ""))
next_performer = escape_quotes(nextsong.get("performer", ""))
next_date = escape_quotes(nextsong.get("date", ""))

# Output bash variables directly
output = f"""
state='{escape_quotes(state)}'
song_position='{song_position}'
song_length='{song_length}'
elapsed='{elapsed}'
total_time='{total_time}'
percent_time='{percent_time:.2f}'
filepath='{filepath}'
title='{title}'
artist='{artist}'
album_artist='{album_artist}'
album='{album}'
year='{year}'
volume='{volume}'
repeat='{repeat}'
single='{single}'
random='{random}'
consume='{consume}'
disc='{disc}'
genre='{genre}'
track='{track}'
mb_artistid='{mb_artistid}'
mb_albumid='{mb_albumid}'
mb_trackid='{mb_trackid}'
mb_reltrackid='{mb_reltrackid}'
comment='{comment}'
performer='{performer}'
date='{date}'

# Next song variables
next_filepath='{next_filepath}'
next_title='{next_title}'
next_artist='{next_artist}'
next_album_artist='{next_album_artist}'
next_album='{next_album}'
next_disc='{next_disc}'
next_genre='{next_genre}'
next_track='{next_track}'
next_mb_artistid='{next_mb_artistid}'
next_mb_albumid='{next_mb_albumid}'
next_mb_trackid='{next_mb_trackid}'
next_mb_reltrackid='{next_mb_reltrackid}'
next_comment='{next_comment}'
next_performer='{next_performer}'
next_date='{next_date}'
"""

print(output)

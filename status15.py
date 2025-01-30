#!/usr/bin/env python3
import subprocess
import os
import mpd

# ANSI color codes
class Colors:
    tput0   = "\033[0m"
    bold    = "\033[1m"
    boldoff = "\033[22m"
    itl     = "\033[3m"
    itloff  = "\033[23m"
    green   = "\033[32m"
    red     = "\033[31m"
    yellow  = "\033[33m"
    gray    = "\033[37m"
    white   = "\033[37m"

# Command to grep the values directly from the config file
def get_config_value(key, filepath):
    try:
        result = subprocess.run(
            f"grep -Po '(?<=^{key}=).*' {filepath}",
            shell=True,
            check=True,
            stdout=subprocess.PIPE,
            universal_newlines=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError:
        return None

# List of possible config file locations
config_locations = [
    os.path.expanduser("~/.config/mpd-local.conf"),
    os.path.expanduser("./mpd-local.conf"),
    "/etc/mpd-local.conf"
]

# Iterate through config locations to find valid values
mpdhost, mpdport = None, None
for config_file in config_locations:
    if os.path.isfile(config_file):
        mpdhost = get_config_value('mpdhostfqdn', config_file)
        mpdport = get_config_value('mpdport', config_file)
        if mpdhost and mpdport:
            break

# Fallback to environment variables
if not mpdhost:
    mpdhost = os.getenv("MPD_HOST", "localhost")
if not mpdport:
    mpdport = os.getenv("MPD_PORT", "6600")
#print(f'MPD Host: {mpdhost}')
#print(f'MPD Port: {mpdport}')

# Example: Connect to MPD using the extracted values
client = mpd.MPDClient()
client.connect(mpdhost, int(mpdport))

##!/usr/bin/env python3
#import subprocess
#import mpd
#
#
## ANSI color codes
#class Colors:
#    tput0   = "\033[0m"
#    bold    = "\033[1m"
#    boldoff = "\033[22m"
#    itl     = "\033[3m"
#    itloff  = "\033[23m"
#    green   = "\033[32m"
#    red     = "\033[31m"
#    yellow  = "\033[33m"
#    gray    = "\033[37m"
#    white   = "\033[37m"
#
## Command to grep the values directly from the config file
#def get_config_value(key):
#    try:
#        result = subprocess.run(
#            f"grep -Po '(?<=^{key}=).*' ~/.config/mpd-local.conf",
#            shell=True,
#            check=True,
#            stdout=subprocess.PIPE,
#            universal_newlines=True
#        )
#        return result.stdout.strip()
#    except subprocess.CalledProcessError:
#        return None
#
## Get the mpdhost and mpdport using grep
#mpdhost = get_config_value('mpdhostfqdn')
#mpdport = get_config_value('mpdport')
#
##print(f'MPD Host: {mpdhost}')
##print(f'MPD Port: {mpdport}')
#
## Example: Connect to MPD using the extracted values
#client = mpd.MPDClient()
#client.connect(mpdhost, int(mpdport))

# Escape single quotes in strings
#def escape_quotes(string):
#    return string.replace("'", "'\\''") if string else ""
#def escape_quotes(value):
#    if isinstance(value, list):
#        return ", ".join([v.replace("'", "'\\''") for v in value])  # Escape and join list items
#    elif isinstance(value, str):
#        return value.replace("'", "'\\''")
#    else:
#        return ""

#def escape_quotes(value):
#    if isinstance(value, list):
#        # Escape single quotes and join the list items into a single string
#        return ", ".join([v.replace("'", "'\\''") for v in value])
#    elif isinstance(value, str):
#        return value.replace("'", "'\\''")  # Escape single quotes in a string
#    else:
#        return ""
#def escape_quotes(value):
#    if isinstance(value, list):
#        return ", ".join([v.replace("'", "'\\''") if isinstance(v, str) else "" for v in value])  # Ensure list items are strings
#    elif isinstance(value, str):
#        return value.replace("'", "'\\''")
#    else:
#        return ""
#def escape_quotes(value):
#    if isinstance(value, list):
#        # Join list elements into a string with commas and escape each string
#        return ", ".join([v.replace("'", "'\\''") for v in value if isinstance(v, str)])
#    elif isinstance(value, str):
#        # Escape single quotes in a string
#        return value.replace("'", "'\\''")
#    else:
#        # Default to an empty string if value is neither a list nor a string
#        return ""
#def escape_quotes(value):
#    if isinstance(value, list):
#        # If value is a list, apply escape_quotes to each string element and join them with commas
#        return ", ".join([escape_quotes(v) for v in value if isinstance(v, str)])
#    elif isinstance(value, str):
#        # If value is a string, escape the quotes
#        return value.replace("'", "'\\''")
#    else:
#        # If it's neither a list nor a string, return an empty string
#        return ""
def escape_quotes(value):
    if isinstance(value, list):
        # If value is a list, apply escape_quotes to each element and join them with commas
        return ", ".join([escape_quotes(v) for v in value])  # Apply escape_quotes recursively
    elif isinstance(value, str):
        # If value is a string, escape the quotes
        return value.replace("'", "'\\''")
    else:
        # If it's neither a list nor a string, return an empty string
        return ""


#client = mpd.MPDClient()
#client.connect( [—redacted—] )

# Escape single quotes in strings
def escape_quotes(string):
    return string.replace("'", "'\\''") if string else ""

# Get current song and next song details from MPD
status = client.status()
currentsong = client.currentsong()

# Extract variables similar to your existing bash variables
state = status.get("state", "")

# The state variable gets formatting later on; u_state is unformatted
u_state = state

# Get song_position, convert to integer, increment by 1
###song_position = status.get("song", "")
song_position = str(int(status.get("song", "0")) + 1)
song_length = status.get("playlistlength", "")
# Ensure the current song position is not greater than the playlist length
if song_length.isdigit() and int(song_position) > int(song_length):
    song_position = song_length  # Cap position to playlist length
song_id = currentsong.get("id", "")
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

#repeat = status.get("repeat", "")
#single = status.get("single", "")
#random = status.get("random", "")
#consume = status.get("consume", "")

#repeat = "✅" if status.get("repeat", False) else "❌"
#repeat = "✅" if status.get("repeat") == "1" else "❌"
#if repeat == 1:
#    repeat = f"{Colors.bold}{Colors.green}⟳{Colors.tput0}"
#else:
#    repeat = f"{Colors.white}⟳{Colors.tput0}"

u_repeat = status.get("repeat", "")
repeat = f"{Colors.bold}{Colors.green}⟳{Colors.tput0}" if status.get("repeat") == "1" else f"{Colors.white}⟳{Colors.tput0}"

single = "✅" if status.get("single") == "1" else ""
#random_value = status.get("random", "off")  # Default to "off"
#random = "✅" if random_value in [True, "1"] else "❌"
random = "✅" if status.get("random") == "1" else "❌"
consume = "✅" if status.get("consume") == "1" else "❌"

#disc = escape_quotes(currentsong.get("disc", ""))
disc = (currentsong.get("disc", ""))
#genre = escape_quotes(currentsong.get("genre", ""))
genre = ", ".join([escape_quotes(g) for g in currentsong.get("genre", [])]) if isinstance(currentsong.get("genre", ""), list) else escape_quotes(currentsong.get("genre", ""))
#track = escape_quotes(currentsong.get("track", ""))
# Update to handle list cases
track = escape_quotes("".join(currentsong.get("track", "")) if isinstance(currentsong.get("track", ""), list) else currentsong.get("track", ""))
mbartistid = currentsong.get("musicbrainz_artistid", "")
mbalbumid = currentsong.get("musicbrainz_albumid", "")
mbtrackid = currentsong.get("musicbrainz_trackid", "")
mbreltrackid = currentsong.get("musicbrainz_releasetrackid", "")
comment = escape_quotes(currentsong.get("comment", ""))
#performer = escape_quotes(currentsong.get("performer", ""))
# Get performer and ensure it's a string
performer_raw = currentsong.get("performer", "")
performer = ""
if isinstance(performer_raw, list):
    performer = ", ".join([escape_quotes(p) for p in performer_raw])  # Join the list elements into a single string
else:
    performer = escape_quotes(performer_raw)

date = escape_quotes(currentsong.get("date", ""))  # Escape since it's a text field

# Format state
if state == "play":
#    state = f"{Colors.green}{Colors.bold}{state}{Colors.tput0}"
    state = f"{Colors.green}{Colors.bold}playing{Colors.white}"
elif state == "pause":
#    state = f"{Colors.red}{state}{Colors.tput0}"
    state = f"{Colors.red}paused{Colors.white}{Colors.itl}"

# Get the next song's details
nextsongid = status.get("nextsongid", "")
nextsong = client.playlistid(nextsongid)[0] if nextsongid else {}

# Extract the next song details and create new variables for them
next_filepath = escape_quotes(nextsong.get("file", ""))
next_id = nextsong.get("id", "")
next_title = escape_quotes(nextsong.get("title", ""))
next_artist = escape_quotes(nextsong.get("artist", ""))
next_album_artist = escape_quotes(nextsong.get("albumartist", ""))
next_album = escape_quotes(nextsong.get("album", ""))
#next_disc = escape_quotes(nextsong.get("disc", ""))
next_disc = (nextsong.get("disc", ""))
#next_genre = escape_quotes(nextsong.get("genre", ""))
next_genre = ", ".join([escape_quotes(g) for g in nextsong.get("genre", [])]) if isinstance(nextsong.get("genre", ""), list) else escape_quotes(nextsong.get("genre", ""))
#next_track = escape_quotes(nextsong.get("track", ""))
next_track = escape_quotes("".join(nextsong.get("track", "")) if isinstance(nextsong.get("track", ""), list) else nextsong.get("track", ""))
next_mbartistid = nextsong.get("musicbrainz_artistid", "")
next_mbalbumid = nextsong.get("musicbrainz_albumid", "")
next_mbtrackid = nextsong.get("musicbrainz_trackid", "")
next_mbreltrackid = nextsong.get("musicbrainz_releasetrackid", "")
next_comment = escape_quotes(nextsong.get("comment", ""))
next_date = escape_quotes(nextsong.get("date", ""))

#next_performer = escape_quotes(nextsong.get("performer", ""))
# Get performer and ensure it's a string
next_performer_raw = nextsong.get("performer", "")
next_performer = ""
if isinstance(next_performer_raw, list):
    next_performer = ", ".join([escape_quotes(p) for p in next_performer_raw])  # Join the list elements into a single string
else:
    next_performer = escape_quotes(next_performer_raw)

try:
    # Calculate percent_time only if elapsed and total_time are numeric
    if elapsed and total_time:
        percent_time = (float(elapsed) / float(total_time) * 100)
        percent_time_formatted = f"{percent_time:.2f}"
    else:
        percent_time_formatted = ""  # Empty string if calculation isn't possible
except (ValueError, ZeroDivisionError):
    percent_time_formatted = ""  # Fallback in case of any error

# Output bash variables directly
# replaced the following below:
# percent_time='{percent_time:.2f}'
output = f"""
song_id='{song_id}'
state='{escape_quotes(state)}'
u_state='{u_state}'
song_position='{song_position}'
song_length='{song_length}'
elapsed='{elapsed}'
total_time='{total_time}'
percent_time='{percent_time_formatted}'
filepath='{filepath}'
title='{title}'
artist='{artist}'
album_artist='{album_artist}'
album='{album}'
year='{year}'
volume='{volume}'
repeat='{repeat}'
u_repeat='{u_repeat}'
single='{single}'
random='{random}'
consume='{consume}'
disc='{disc}'
genre='{genre}'
track='{track}'
mbartistid='{mbartistid}'
mbalbumid='{mbalbumid}'
mbtrackid='{mbtrackid}'
mbreltrackid='{mbreltrackid}'
comment='{comment}'
performer='{performer}'
date='{date}'

# Next song variables
next_id='{next_id}'
next_filepath='{next_filepath}'
next_title='{next_title}'
next_artist='{next_artist}'
next_album_artist='{next_album_artist}'
next_album='{next_album}'
next_disc='{next_disc}'
next_genre='{next_genre}'
next_track='{next_track}'
next_mbartistid='{next_mbartistid}'
next_mbalbumid='{next_mbalbumid}'
next_mbtrackid='{next_mbtrackid}'
next_mbreltrackid='{next_mbreltrackid}'
next_comment='{next_comment}'
next_performer='{next_performer}'
next_date='{next_date}'
"""

print(output)

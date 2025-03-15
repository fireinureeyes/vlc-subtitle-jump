# VLC Subtitle Jump Plugin
VLC Plugin offering the option to jump to the timestamp of the next or previous subtitle, or by maximum the defined value. Setting an offset value is also possible.
Helps to save time watching, while not missing any dialogues.

<p float="left">
<img src="https://raw.githubusercontent.com/fireinureeyes/vlc-subtitle-jump/refs/heads/main/plugin-screenshot.png">
</p>

#### The subtitle file must be in .srt format in the same folder as the video being played, named the same as the video itself
e.g. folder/movie_name.mkv -> folder/movie_name.srt

### 1. Add subtitle_jump.lua to the extensions folder
- Windows: C:\Program Files\VideoLAN\VLC\lua\extensions
- Mac: /Applications/VLC.app/Contents/MacOS/share/lua/extensions/
- Linux: /usr/lib/vlc/lua/extensions/

### 2. Open the plugin
- Windows: VLC > View > Jump subtitle
- Mac: VLC > Extensions > Jump subtitle
- Linux: VLC > View > Jump subtitle

### 3. Optional on Windows
Open keyboard_control.au3 script (by AbdalrahmanHafez) in AutoIt and use the Home and End keyboard shortcuts, even if VLC is in full screen mode 

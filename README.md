# WEDI (Simple wrapper for editor)

Simple bash wrapper for text editor with automatic file selecting

## How to run

Create environmental variable `WEDI_RC` with absolute location to config file, F.E. `~/.config/wedirc`

If you want to use other editor than vi, set environmental variable `EDITOR` or `VISUAL`

`$EDITOR` > `$VISUAL` > vi

`wedi FILE` edit file with editor

`wedi [DEST]` edit last updated file in destination (opening file with wedi)

`wedi -m [DEST]` edit most frequently opened file in destination

`wedi -l [DEST]` list of edited files in folder

`wedi b|a DATE [DEST]` list of edited files before | after date in `YYYY-MM-DD` format


When argument `DEST` isn't set, then wedi is operating with current folder

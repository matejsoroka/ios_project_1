# WEDI (Simple wrapper for editor)

Simple bash wrapper for text editor with automatic file selecting

## How to run
`wedi FILE` edit file with editor

`wedi [DEST]` edit last updated file in destination (opening file with wedi)

`wedi -m [DEST]` edit most frequently opened file in destination

`wedi -l [DEST]` list of edited files in folder

`wedi b|a DATE [DEST]` list of edited files before | after date in `YYYY-MM-DD` format


When argument `DEST` isn't set, then wedi is operating with current folder

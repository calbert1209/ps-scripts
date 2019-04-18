# path to taglib dll
$taglibPath = "C:\Users\albert\Documents\WindowsPowerShell\Modules\taglib\taglib-sharp.dll"

# see: https://stackoverflow.com/a/12924252
Add-Type -Path $taglibPath

# an example file
$untruePath = "C:\Users\albert\Documents\file-conversion\audio\inbox\Burial-Untrue.mp3"


$file = [TagLib.Mpeg.AudioFile]::new($untruePath)

# list all tags
$file.Tag

# How to change a tag individually, and save changes...
# $file.Tag.Album = "Untrue"
# $file.Save()

# call powershell from node.js
# https://stackoverflow.com/a/10181488

# or use edge.js to execute c# code on CLR in node.js
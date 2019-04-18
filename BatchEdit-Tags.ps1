
# path to taglib dll
$taglibPath = "C:\Users\albert\Documents\WindowsPowerShell\Modules\taglib\taglib-sharp.dll"

# see: https://stackoverflow.com/a/12924252
Add-Type -Path $taglibPath

# an example file
# TODO this path is no longer valid
# $albumFolderPath = "C:\Users\albert\Documents\ytdl\output\odyssey sonne"

$files = Get-ChildItem -Path $albumFolderPath
$global:index = 1
foreach ($file in $files) {
  $tagLibFile = [TagLib.Mpeg.AudioFile]::new($($file.FullName))
  # $trackNum = [int]$file.Name.Substring(0,2)
  # $tagLibFile.Tag.Track = $global:index++
  $trackTitle = $($file.BaseName -split " - ")[1]
  $tagLibFile.Tag.Title = $trackTitle
  $tagLibFile.Tag.TrackCount = 7
  $tagLibFile.Tag.Album = "Copia"
  $tagLibFile.Tag.Artists += "Eluvium"

  $tagLibFile.save()
}



# list all tags
# $file.Tag

# How to change a tag individually, and save changes...
# $file.Tag.Album = "Untrue"
# $file.Save()

# call powershell from node.js
# https://stackoverflow.com/a/10181488

# or use edge.js to execute c# code on CLR in node.js
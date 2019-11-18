<#
 #  a wizard to help walk through the process of adding tags
 #  to all the tracks of an album saved in a single folder
 #
 #  depends on `BatchEdit-Tags.ps1` script in same folder
 #  and TagLibSharp package
 #>


Write-Host "=== Greetings. Let's Batch Edit Tags ===" -ForegroundColor Yellow

$directoryPath = Read-Host "Directory path?"
$artistName = Read-Host "Artist's name?"
$albumTitle = Read-Host "Album title?"
$rawTrackCount = Read-Host "Track count?"

$trackCount = 0
$useTrackCount = $false
try {
  $trackCount = [int]$rawTrackCount
  $useTrackCount = $true
}
catch {
  Write-Host "Unable to parse the track count." -ForegroundColor Red
}

$batchEditArgs = @{
  "DirectoryPath"=$directoryPath
  "Artist"=$artistName
  "AlbumTitle"=$albumTitle
}

if ($useTrackCount) {
  $batchEditArgs.Add("TrackCount", $trackCount)
}

. ".\BatchEdit-Tags.ps1" @batchEditArgs

$explore = Read-Host "view in explorer? (y/n)"

if ($explore -eq "y"){
  & explorer.exe $directoryPath
}

Write-Host "Goodbye!" -ForegroundColor Yellow
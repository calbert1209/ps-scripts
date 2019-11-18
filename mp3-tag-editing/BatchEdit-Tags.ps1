<#
 # A script that uses TagLibSharp to edit an mp3 files tags
 # 
 #>

param(

  [Parameter(Mandatory=$true, Position=0)]
    [string]
    $DirectoryPath,
  
    [Parameter(Mandatory=$true, Position=1)]
    [string]
    $Artist,
  
    [Parameter(Mandatory=$true, Position=2)]
    [String]
    $AlbumTitle,
  
    [Parameter(Mandatory=$false, Position=3)]
    [int]
    $TrackCount
  )
  

  <#  For more information about how to use a dll in powershell
   #  see: https://stackoverflow.com/a/12924252
   # 
   #  Download TagLibSharp via nuget
   #  see: https://www.nuget.org/packages/TagLibSharp/2.2.0#
   #
   #  $env:TaglibSharpPath points to local location of dll
   #>
  Add-Type -Path $env:TaglibSharpPath
  $DELIMITER = "-"
  
  $files = Get-ChildItem -Path $DirectoryPath -Filter "*.mp3"
  $global:index = 1
  foreach ($file in $files) {
    $tagLibFile = [TagLib.Mpeg.AudioFile]::new($($file.FullName))
    try {
      $trackNumberString = $($file.BaseName -split $DELIMITER)[0]
      $trackNumber = [int]$trackNumberString
      $tagLibFile.Tag.Track = $trackNumber
    }
    catch {
     Write-Host "Could not parse track for $trackNumber" 
    }
    
    $trackTitle = $($file.BaseName -split $DELIMITER)[1]
    $tagLibFile.Tag.Title = $trackTitle
    if ($TrackCount){
      $tagLibFile.Tag.TrackCount = $TrackCount
    }
    $tagLibFile.Tag.Album = $AlbumTitle
    $tagLibFile.Tag.Artists += $Artist
  
    $tagLibFile.save()
  }

$executingScriptDirPath = Split-Path $PSCommandPath -Parent
$imageLoader = Join-Path $executingScriptDirPath "Import-FfmpegImageUtilities.ps1"
. $imageLoader
function ConvertTo-Gif {
  param(
    # absolute path to file
    [Parameter(Mandatory = $true)]
    [String]
    $FilePath,

    # image id of ffmpeg container
    # defaults to jrottenberg/ffmpeg:4.1-scratch
    [Parameter(Mandatory = $false)]
    [String]
    $ImageID = "7695c674109a",

    # width of output GIF (scales according to aspect ratio)
    [Parameter(Mandatory = $false)]
    [Int16]
    $Width = 320,

    # frame rate
    [Parameter(Mandatory = $false)]
    [Int16]
    $FrameRate = 10,

    #infinite loop switch
    [Parameter(Mandatory = $false)]
    [switch]
    $NoLoop
  )

  $file = Get-ChildItem -Path $FilePath
  $name = $file.Name
  $basename = $file.BaseName
  $directoryPath = $file.Directory.FullName

  
  $inputArg = "-i `"tmp/$name`""
  $optionsArg = "-vf `"fps=$FrameRate,scale=$($Width):-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse`""
  $loopArg = "-loop 0"
  if ($NoLoop) {
    $loopArg = "";
  }
  $outputArg = "`"tmp/$basename.gif`""

  Invoke-FfmpegImage -ImageID $ImageID -WorkingDir $directoryPath -Arguments @($inputArg, $optionsArg, $loopArg, $outputArg)
}

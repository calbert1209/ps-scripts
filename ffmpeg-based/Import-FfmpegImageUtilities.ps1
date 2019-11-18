
function Invoke-FfmpegImage {
  param(
    # image id of ffmpeg container
    # defaults to jrottenberg/ffmpeg:4.1-scratch
    [Parameter(Mandatory = $false)]
    [string]
    $ImageID = "7695c674109a",

    #args list
    [Parameter(Mandatory = $true)]
    [string[]]
    $Arguments,

    #local working directory
    [Parameter(Mandatory = $true)]
    [string]
    $WorkingDir
  )

  $volumeBind = "-v=$($WorkingDir):/tmp"
  $hideBanner = "-hide_banner"
  $argList = @("run", $volumeBind, $ImageID, $hideBanner) + $Arguments

  Start-Process -FilePath "docker" -ArgumentList $argList -Wait
}

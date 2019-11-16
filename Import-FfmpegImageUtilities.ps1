
function Invoke-FfmpegImage {
  param(
    # image id of ffmpeg container
    [Parameter(Mandatory = $true)]
    [string]
    $ImageID,

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
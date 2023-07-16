
function Invoke-Ffmpeg {
  param(
    # image id of ffmpeg container
    # defaults to jrottenberg/ffmpeg:4.1-scratch
    [Parameter(Mandatory = $false)]
    [string]
    $ImageID = "7695c674109a",

    #args list
    [Parameter(Mandatory = $true)]
    [string[]]
    $Arguments
  )

  Start-Process -FilePath "ffmpeg" -ArgumentList $Arguments -Wait
}

# TODO: add function to call ffprobe within image
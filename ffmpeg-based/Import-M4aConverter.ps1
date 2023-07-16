$executingScriptDirPath = Split-Path $PSCommandPath -Parent
$imageLoader = Join-Path $executingScriptDirPath "Import-FfmpegUtility.ps1"
. $imageLoader

function ConvertFrom-m4a {
    param(
        # Input File
        [Parameter(Mandatory=$true)]
        [string]
        $Path
    )

    $video = Get-Item -Path $Path
    $source = $video.FullName
    $target = $source.Replace("m4a", "mp3")
    $arguments = @("-i `"$source`"", "`"$target`"")
    Invoke-Ffmpeg -WorkingDir $video.Directory -Arguments $arguments
}

function Convert-m4aFiles {
    param (
        # path to directory holding m4a files
        [Parameter(Mandatory=$true)]
        [string]
        $DirPath
    )

    $videos = Get-ChildItem -Path $DirPath -Filter *.m4a
    $count = $videos.Count
    $index = 0

    foreach ($video in $videos) {
        $activity = "Converting $($video.Name)"
        $status = "$($index + 1) of $count"
        $percentComplete = $index / $count * 100
        Write-Progress -Activity $activity -Status $status -PercentComplete $percentComplete
        ConvertFrom-m4a -Path $video.FullName
        $index++
    }
}
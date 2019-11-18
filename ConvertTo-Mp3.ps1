$FfmpegPath = "E:\applications\ffmpeg\4.2.1\bin\ffmpeg.exe"
$target = "C:\Users\albert\Documents\file-conversion\video-files\inbox"

function Initialize-Folder {
    param([string] $DirPath)

    if(!(Test-Path $DirPath)) {
        Write-Host "creating" $DirPath
        New-Item -Path $DirPath -ItemType Directory
    }
}

function ConvertTo-Mp3 {
    param([string] $targetDir)

    $fileTypes = @(".mp4"; ".aac"; ".m4a")
    $targetDirLeaf = Split-Path $targetDir -Leaf
    $videos = Get-ChildItem -Path $targetDir | Where-Object {$fileTypes.Contains($($_.Extension))}

    $outputDir = "${env:HOMEPATH}\Documents\file-conversion\audio\$targetDirLeaf"
    Initialize-Folder -DirPath $outputDir
    $videoCount = $videos.Count
    $index = 0

    foreach ($video in $videos){

        $currentAction = "Converting $($video.Name)"

        Write-Progress -Activity $currentAction -Status "Converting $($index + 1) of $videoCount" -PercentComplete ($index / $videoCount * 100)
        $outputBaseName = $video.BaseName -replace " ", "-"
        $outputName = "$($outputBaseName).mp3"

        $outputPath = Join-Path $outputDir $outputName
        $args = "-i `"$($video.FullName)`" `"$outputPath`""
        Start-Process -FilePath $FfmpegPath -ArgumentList $args -Wait -WindowStyle Hidden -LoadUserProfile

        $index++
    }
}

ConvertTo-Mp3 $target
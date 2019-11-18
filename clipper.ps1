$FfmpegPath = "E:\applications\ffmpeg\4.2.1\bin\ffmpeg.exe"

function Convert-mp4 {
    param([string] $targetFile)

    $targetDirLeaf = Split-Path $targetDir -Leaf 
    $videos = Get-ChildItem -Path $targetDir -Filter *.mp4
    
    $outputDir = "${env:HOMEPATH}\Documents\file-conversion\audio\$targetDirLeaf"
    Ensure-Folder -DirPath $outputDir
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
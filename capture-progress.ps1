$FfmpegPath = "E:\applications\ffmpeg\4.2.1\bin\ffmpeg.exe"
$target = "C:\Users\albert\Documents\file-conversion\video-files\wake\test.mp4"

function Convert-Video {
    param([string] $Path)
    
    $inputFile = Get-Item -Path $Path
    $outputFileName = $InputFile.FullName -replace ".mp4",".mp3"
    $args = "-i `"$($InputFile.FullName)`" `"$outputFileName`""
        
    Start-Process -FilePath $FfmpegPath -ArgumentList $args -Wait -LoadUserProfile

    $psi = New-object System.Diagnostics.ProcessStartInfo
    $psi.CreateNoWindow = $true
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.FileName = $FfmpegPath
    $psi.Arguments = $args
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $psi
    $process.Start() | Out-Null
    $output = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    
    Write-Host $output
}

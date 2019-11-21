
Param([switch]$Force)

# TODO dot source Get-CapturesList.ps1
."./Get-ImageSize.ps1"
."./Test-Elevation.ps1"

$isElevated = Test-Elevation
$OUTPUT_FOLDER_NAME = "Portraits"
$OUTPUT_FOLDER_PATH = "./$OUTPUT_FOLDER_NAME"

$localStateAssetsPath = "Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\"
$pathResolver = {"c:\users\$($_.Name)\AppData\Local\$localStateAssetsPath"}
$tmpGuid = New-Guid
$tempFolder = New-Item -Path $env:TEMP -Name $tmpGuid -ItemType Directory

$assetFolderPaths = $null
$isElevated = Test-Elevation
if ($isElevated) {
    $assetFolderPaths = Get-LocalUser `
        | Where-Object { $_.Enabled } `
        | Select-Object @{n="path";e=$pathResolver} `
        | Select-Object -ExpandProperty path
}
else {
    $assetFolderPaths = Join-Path $env:LOCALAPPDATA $localStateAssetsPath
}

try {
    $allAssets = Get-ChildItem -Path $assetFolderPaths `
    | Copy-Item -Destination {(Join-Path $tempFolder "$($_.BaseName.Substring(0,12)).jpg")} -PassThru

    $copiables = $allAssets `
        | Select-Object *, @{n="Size";e={Get-ImageSize -Path $_.FullName}} `
        | Where-Object { [long]$_.Size.Height -gt 1080 }

    if ($copiables.Count -le 0){
        Write-Host "no new items found"
        return
    }

    # TODO: reconcile with remote list

    if (!(Test-Path $OUTPUT_FOLDER_PATH)) { 
        New-Item -Path . -Name $OUTPUT_FOLDER_NAME -ItemType Directory
    }

    if ($Force) {
        Write-Host "`n|::|:: New Items Added: ::|::|`n"
        $copiables `
            | ForEach-Object { Write-Host "$($_.Name)" -ForegroundColor Green }
        
        $copiables `
            | Copy-Item -Destination $OUTPUT_FOLDER_PATH

        return
    }
    
    $previousItems = Get-ChildItem -Path $OUTPUT_FOLDER_PATH | Select-Object *, @{n="Size";e={Get-ImageSize -Path $_.FullName}}
    
    $newItems = $null
    if ($previousItems.Count -gt 0){
        $newItems = Compare-Object -ReferenceObject $copiables -DifferenceObject $previousItems `
            | Where-Object SideIndicator -eq "<=" `
            | Select-Object -ExpandProperty InputObject
    }
    else {
        $newItems = $copiables
    }
    
    # === Copy To Local Folder & Report ===
    if ($newItems.Count -gt 0){
        
        Write-Host "`n|::|:: New Items Added: ::|::|`n"
        $newItems `
        | ForEach-Object { Write-Host "$($_.Name)" -ForegroundColor Green }
        
        $newItems `
            | Copy-Item -Destination ".\Landscapes"
    }
    else {
        Write-Host "`n>>>> No new items found. <<<<`n" -ForegroundColor Yellow
    }
        
}
catch {
    $_
    Pause
}
finally {
    Remove-Item -Path $tempFolder -Recurse
}
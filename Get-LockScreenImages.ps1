$regItemPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Lock Screen\Creative'
$regItemProps = Get-ItemProperty -Path $regItemPath
$hotspotImageFolderPath = $regItemProps.HotspotImageFolderPath
$hotspotImages = Get-ChildItem -Path $hotspotImageFolderPath

# TODO copy to work dir
# TODO truncate name & add jpg extension
# TODO filter out non-landscapes & icons

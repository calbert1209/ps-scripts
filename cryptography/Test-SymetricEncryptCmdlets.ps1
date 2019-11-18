. .\Import-SymetricEncryptCmdlets.ps1

$key = Get-KeyBytes "HelloFromTheOtherSide"
$plainText = "My deepest darkest secrets should never see the light of day."

$encryptedData = ConvertTo-EncryptedData -Key $key -PlainText $plainText
Write-Host "=== encrypted data ===`n`n$($encryptedData)`n`n"

$decryptedData = ConvertFrom-EncryptedData -Key $key -Data $encryptedData
Write-Host "=== decrypted data ===`n`n$($decryptedData)`n`n"

$isSame = $decryptedData -eq $plainText

if($isSame) {
  Write-Host "Passed" -ForegroundColor Green
}
else {
  Write-Host "Failed" -ForegroundColor Red
}
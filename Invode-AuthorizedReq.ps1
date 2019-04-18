$cred = Get-Credential
# Here a personal access token is required in place of a password
# a new access token can be created at https://github.com/settings/tokens
$userName = $cred.UserName
$netCred = $cred.GetNetworkCredential()
$credPass = $netCred.Password
$pair = "$($userName):$($credPass)"

$pairBytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$encodedCreds = [System.Convert]::ToBase64String($pairBytes)
$basicAuthValue = "Basic $encodedCreds"
$headers = @{ Authorization = $basicAuthValue }
$testUri = "https://raw.githubusercontent.com/loilo-inc/loilonote-ios/develop3/LoiLoNote/Base.lproj/Localizable.strings"
$req = Invoke-WebRequest -Uri $testUri -Headers $headers
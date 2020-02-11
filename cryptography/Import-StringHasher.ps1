function Get-StringHash {
  param(
    # Parameter help description
    [Parameter(Mandatory=$true, Position=0)]
    [string]
    $String,

    # Parameter help description
    [Parameter(Mandatory=$false, Position=1)]
    [string]
    $Algorithm = "SHA256"
  )

  if ($Algorithm.ToLowerInvariant() -eq "md5") {
    $Script:hasher = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
  } else {
    $Script:hasher = New-Object -TypeName System.Security.Cryptography.SHA256CryptoServiceProvider
  }

  $bytes = [System.Text.Encoding]::UTF8.GetBytes($String)
  $hashedBytes = $Script:hasher.ComputeHash($bytes)
  [System.BitConverter]::ToString($hashedBytes).ToLowerInvariant() -replace "-", ""
}
<#
  Hint: http://www.get-powershell.com/post/2008/12/13/Encrypting-and-Decrypting-Strings-with-a-Key-in-PowerShell.aspx
#>

function Get-KeyBytes {
  Param(
    # symetric key as string
    [Parameter(Mandatory, Position=0)]
    [string]
    $KeyString
  )

  $keyStringBytes = [System.Text.Encoding]::UTF8.GetBytes($KeyString)
  $sha256 = New-Object System.Security.Cryptography.SHA256Managed
  $hash = $sha256.ComputeHash($keyStringBytes)
  $sha256.Dispose()
  return $hash
}

function Get-Password {
  try {
    $secureString = Read-Host -AsSecureString -Prompt "password"
    $unsecureString = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString))
    $keyStringBytes = [System.Text.Encoding]::UTF8.GetBytes($unsecureString)
    $sha256 = New-Object System.Security.Cryptography.SHA256Managed
    $hash = $sha256.ComputeHash($keyStringBytes)
    return $hash
  }
  finally {
    $sha256.Dispose()
  }  
}

function ConvertTo-EncryptedData {
  Param(
    # key in byte array form
    [Parameter(Mandatory, Position=0)]
    [Byte[]]
    $Key,

    # plain text string
    [Parameter(Mandatory, Position=1, ValueFromPipeline=$true)]
    [String]
    $PlainText
  )

  $secureStr = New-Object System.Security.SecureString
  $chars = $PlainText.ToCharArray()
  $chars | ForEach-Object { $secureStr.AppendChar($_) }
  return ConvertFrom-SecureString -SecureString $secureStr -Key $Key
}

function ConvertFrom-EncryptedData {
  Param(
    # key in byte array form
    [Parameter(Mandatory, Position=0)]
    [Byte[]]
    $Key,

    # encrypted string
    [Parameter(Mandatory, Position=1, ValueFromPipeline=$true)]
    [String]
    $Data
  )

  $Data `
    | ConvertTo-SecureString -Key $Key `
    | ForEach-Object {
      $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($_)
      [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    }
}
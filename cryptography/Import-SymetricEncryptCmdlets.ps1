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

  try {
    $keyStringBytes = [System.Text.Encoding]::UTF8.GetBytes($KeyString)
    $sha256 = New-Object System.Security.Cryptography.SHA256Managed
    return $sha256.ComputeHash($keyStringBytes)
  }
  finally {
    $sha256.Dispose()
  }
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
    if ($null -ne $sha256) {
      $sha256.Dispose()
    }
    if ($null -ne $secureString) {
      $secureString.Dispose()
    }
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

  try {
    $secureStr = New-Object System.Security.SecureString
    $chars = $PlainText.ToCharArray()
    $chars | ForEach-Object { $secureStr.AppendChar($_) }
    return ConvertFrom-SecureString -SecureString $secureStr -Key $Key
  }
  finally {
    if ($null -ne $secureStr) {
      $secureStr.Dispose()
    }
  }
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

  Begin {

  }
  Process {
    try {
      $secureStr = ConvertTo-SecureString -String $Data -Key $Key
      $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureStr)
      return [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    }
    finally {
      if ($null -ne $secureStr) {
        $secureStr.Dispose()
      }
    }
  }
  End {

  }
}

function Get-EncryptedContent {
  Param(
    # encrypted file's path
    [Parameter(Mandatory, Position=0)]
    [String]
    $Path,

    # key in byte array form
    [Parameter(Mandatory, Position=1)]
    [Byte[]]
    $Key
  )

  try {
    $encryptedContent = Get-Content -Path $Path -Encoding UTF8 -Raw
    $secureStr = ConvertTo-SecureString -String $encryptedContent -Key $Key
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureStr)
    [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
  }
  finally {
    if ($null -ne $secureStr) {
      $secureStr.Dispose()
    }
  }

}

function Out-EncryptedFile {
  param(
    # path for created file
    [Parameter(Mandatory, Position=0)]
    [String]
    $Path,
  
    # key in byte array form
    [Parameter(Mandatory, Position=1)]
    [Byte[]]
    $Key,

    # encrypted string
    [Parameter(Mandatory, Position=2, ValueFromPipeline=$true)]
    [String]
    $Data
  )

  Begin {
    $collection = @()
  }
  Process {
    $collection += $Data
  }
  End {
    $lines = New-Object System.Text.StringBuilder
    $collectionLength = $collection.Length
    for ($i = 0; $i -lt $collectionLength; $i++) {
      $lines.Append($collection[$i]) | Out-Null
      if ($i -lt ($collectionLength - 1)) {
        $lines.Append("`n") | Out-Null
      }
    }
    
    try {
      $chars = $lines.ToString().ToCharArray()
      $secureStr = New-Object System.Security.SecureString
      $chars | ForEach-Object { $secureStr.AppendChar($_) }
      ConvertFrom-SecureString -SecureString $secureStr -Key $Key `
        | Out-File -FilePath $Path -Encoding utf8
    }
    finally {
      if ($null -ne $secureStr) {
        $secureStr.Dispose()
      }
    }
  }
}

# function Test-Idea {
#   $testFile = "C:\users\albert\Desktop\test.txt"
#   $key = Get-KeyBytes -KeyString "mi6"
#   # $array = "one", "two", "three"
#   $secrets = @{
#     "dev"=@{
#       "db_user"="dbadmin"; 
#       "db_pass"="123456";
#     }
#     "production"=@{
#       "db_user"="lord_vorgon_the_destroyer"; 
#       "db_pass"="fluffy_the_kitten";
#     }
#   }
#   ConvertTo-Json -InputObject $secrets -Depth 2 -Compress `
#     | Out-EncryptedFile -Path $testFile -Key $key
#   $decoded = Get-EncryptedContent -Path $testFile -Key $key
#   ConvertFrom-Json -InputObject $decoded
# }
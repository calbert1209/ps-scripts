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

  $STD_BYTE_LENGTH = 32
  $length = $KeyString.Length
  $standardLengthString = ""


  if ($length -ge $STD_BYTE_LENGTH) {
    $standardLengthString = $KeyString.Substring(0, $STD_BYTE_LENGTH)
  }
  else {
    $standardLengthString = $KeyString.PadRight($STD_BYTE_LENGTH, '0')
  }

  $encoding = New-Object System.Text.ASCIIEncoding
  return $encoding.GetBytes($standardLengthString)
}

function ConvertTo-EncryptedData {
  Param(
    # key in byte array form
    [Parameter(Mandatory, Position=0)]
    [Byte[]]
    $Key,

    # plain text string
    [Parameter(Mandatory, Position=1)]
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
    [Parameter(Mandatory, Position=1)]
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
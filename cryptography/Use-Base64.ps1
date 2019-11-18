
function ConvertTo-Base64 {

  Param (
    [Parameter(Mandatory=$true)]
    [string]
    $Source
  )

  $bytes = [System.Text.Encoding]::UTF8.GetBytes($Source)
  return [System.Convert]::ToBase64String($bytes)
}

function ConvertFrom-Base64 {

  Param (
    [Parameter(Mandatory=$true)]
    [string]
    $Source
  )

  $bytes = [System.Convert]::FromBase64String($Source)
  return [System.Text.Encoding]::UTF8.GetString($bytes)

}
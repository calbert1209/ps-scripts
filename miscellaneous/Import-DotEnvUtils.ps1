
function Get-DotEnvDictionary {

  param (
      [Parameter(Mandatory=$false)]
      [String]
      $FilePath = ".\.env"
  )
    
  $rawData = Get-Content -Path $FilePath `
      | Where-Object {$_[0] -notmatch "`\s*#"}  `
      | Where-Object {![String]::IsNullOrWhiteSpace($_)}
  
  $dataDict = @{}
  
  foreach ($line in $rawData) {
      $keyValuePair = $line.Split('=')
      $dataDict.Add($keyValuePair[0], $keyValuePair[1])
  }

  return $dataDict
}

function Set-DotEnvVariables {
  param(
    # Parameter help description
    [Parameter(Mandatory=$false)]
    [string]
    $FilePath = ".\.env"
  )

  $rawData = Get-Content -Path $FilePath `
      | Where-Object {$_[0] -notmatch "`\s*#"}  `
      | Where-Object {![String]::IsNullOrWhiteSpace($_)} 
 
  foreach ($line in $rawData) {
      $keyValuePair = $line.Split('=')
      $key = $keyValuePair[0]
      $value = $keyValuePair[1]
      New-Item -Path Env: -Name $key -Value $value | Out-Null
  }
}